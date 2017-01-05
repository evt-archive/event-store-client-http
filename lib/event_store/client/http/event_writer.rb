 module EventStore
  module Client
    module HTTP
      class EventWriter
        dependency :request, EventSource::EventStore::HTTP::Request::Post
        dependency :logger, Telemetry::Logger

        def self.build(session: nil)
          logger.opt_trace "Building event writer"

          session ||= Session.build

          new.tap do |instance|
            post = EventSource::EventStore::HTTP::Request::Post.configure instance, session: session
            post.require_leader

            Telemetry::Logger.configure instance
            logger.opt_debug "Built event writer"
          end
        end

        def self.configure(receiver, session: nil, attr_name: nil)
          attr_name ||= :writer

          instance = build(session: session)
          receiver.public_send "#{attr_name}=", instance
          instance
        end

        def write(event_data, stream_name, expected_version: nil)
          stream_name = self.stream_name(stream_name)

          logger.opt_trace "Writing event data (Stream Name: #{stream_name}, Expected Version: #{!!expected_version ? expected_version : '(none)'})"
          logger.opt_data "(#{event_data.class}) #{event_data.inspect}"

          batch = batch(event_data)

          write_batch(batch, stream_name, expected_version: expected_version).tap do
            logger.opt_debug "Wrote event data (Stream Name: #{stream_name}, Expected Version: #{!!expected_version ? expected_version : '(none)'})"
          end
        end

        def write_batch(batch, stream_name, expected_version: nil)
          logger.opt_trace "Writing batch (Stream Name: #{stream_name}, Number of Events: #{batch.length}, Expected Version: #{!!expected_version ? expected_version : '(none)'})"

          json_text = Transform::Write.(batch, :json)
          logger.opt_data "(#{json_text.class}) #{json_text}"

          path = path(stream_name)

          retry_count = 0
          retry_limit = Defaults.retry_limit
          retry_delay = Defaults.retry_delay

          begin
            request.(path, json_text, expected_version: expected_version).tap do |instance|
              logger.opt_debug "Wrote batch (Stream Name: #{stream_name}, Path: #{path}, Number of Events: #{batch.length}, Expected Version: #{!!expected_version ? expected_version : '(none)'})"
            end
          rescue Request::Post::WriteTimeoutError => error
            logger.warn "Stream Name: #{stream_name}, Path: #{path}, Number of Events: #{batch.length}, Expected Version: #{!!expected_version ? expected_version : '(none)'}, RetryCount: #{retry_count}/#{retry_limit}"

            raise error if retry_count >= 3

            sleep retry_delay

            retry_count += 1
          end
        end

        def batch(event_data)
          logger.opt_trace "Constructing batch"
          EventStore::Client::HTTP::EventData::Batch.build(event_data).tap do
            logger.opt_debug "Constructed batch"
          end
        end

        def path(stream_name)
          "/streams/#{stream_name}"
        end

        def stream_name(stream_name_or_uri)
          case stream_name_or_uri
          when URI then stream_name_or_uri.path.sub %r{\A/streams/}, ''
          else stream_name_or_uri
          end
        end

        def self.logger
          @logger ||= Telemetry::Logger.get self
        end

        module Assertions
          def session?(session)
            request.session.equal? session
          end
        end
      end
    end
  end
end
