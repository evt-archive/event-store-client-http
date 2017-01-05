module EventStore
  module Client
    module HTTP
      module Request
        class Get
          configure :request

          include Telemetry::Logger::Dependency

          dependency :session, EventSource::EventStore::HTTP::Session

          attr_accessor :long_poll

          def self.build(session: nil)
            instance = new
            Session.configure instance, session: session
            instance
          end

          def call(path)
            log_attributes = "Path: #{path}"
            logger.opt_trace "Issuing GET (Path: #{path})"

            headers = self.headers

            request = Net::HTTP::Get.new path, headers
            request['Accept'] = media_type

            response = session.(request)

            status_code = response.code.to_i
            response_body = response.body if (200..399).include? status_code

            log_attributes << "StatusCode: #{status_code}, ContentLength: #{response_body&.bytesize}"

            logger.opt_debug "Received GET (#{log_attributes})"
            logger.opt_data "Response body:\n#{response_body}"

            return response_body, status_code
          end
          alias :! :call # TODO: Remove deprecated actuator [Kelsey, Thu Oct 08 2015]

          def headers
            headers = {}
            set_event_store_long_poll_header headers if long_poll
            headers
          end

          def media_type
            'application/vnd.eventstore.atom+json'
          end

          def set_event_store_long_poll_header(request)
            request['ES-LongPoll'] = Defaults.long_poll_duration.to_s
          end

          def enable_long_poll
            self.long_poll = true
          end

          module Defaults
            def self.long_poll_duration
              duration = ENV['LONG_POLL_DURATION']
              duration || 15
            end
          end
        end
      end
    end
  end
end
