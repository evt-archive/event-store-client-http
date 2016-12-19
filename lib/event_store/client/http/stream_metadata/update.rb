module EventStore
  module Client
    module HTTP
      module StreamMetadata
        class Update
          attr_reader :stream_name

          dependency :logger, Telemetry::Logger
          dependency :read_metadata, Read
          dependency :event_writer, EventWriter
          dependency :session, EventSource::EventStore::HTTP::Session

          def initialize(stream_name)
            @stream_name = stream_name
          end

          def self.build(stream_name, session: nil)
            instance = new stream_name

            session = Session.configure instance, session: session

            Read.configure instance, stream_name, session: session, attr_name: :read_metadata
            Telemetry::Logger.configure instance
            EventWriter.configure instance, session: session, attr_name: :event_writer

            instance
          end

          def self.call(stream_name, session: nil, &apply_changes)
            instance = build stream_name, session: session
            instance.(&apply_changes)
          end

          def self.configure(receiver, stream_name, attr_name: nil, session: nil)
            attr_name ||= :update_stream_metadata

            instance = build stream_name, session: session
            receiver.public_send "#{attr_name}=", instance
            instance
          end

          def call(&apply_changes)
            logger.opt_trace "Updating metadata (URI: #{uri.inspect})"

            metadata = read_metadata.()
            return if metadata.nil?

            apply_changes.(metadata)

            event_data, response = write metadata

            logger.opt_trace "Updated metadata (URI: #{uri.inspect})"

            return event_data, response
          end

          def write(metadata)
            logger.opt_trace "Writing stream metadata (URI: #{uri.to_s.inspect})"
            logger.opt_data JSON.pretty_generate(metadata)

            event_data = HTTP::EventData::Write.build(
              :type => 'MetadataUpdated',
              :data => metadata
            )
            event_data.assign_id

            status_code = event_writer.write event_data, uri

            logger.opt_debug "Wrote stream metadata (URI: #{uri.to_s.inspect}, StatusCode: #{status_code}, EventID: #{event_data.id.inspect})"

            return event_data, status_code
          end

          def headers
            {
              'Accept' => media_type
            }
          end

          def media_type
            'application/vnd.eventstore.atom+json'
          end

          def uri
            @uri ||= URI::Get.(stream_name, session: session)
          end
        end
      end
    end
  end
end
