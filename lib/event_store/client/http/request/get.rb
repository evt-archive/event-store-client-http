module EventStore
  module Client
    module HTTP
      module Request
        class Get
          include Request

          attr_accessor :long_poll

          def call(path)
            logger.trace "Getting from #{path}"

            body, response = get(path)

            logger.info "GET Response\nPath: #{path}\nStatus: #{response.status_code} #{response.reason_phrase}"
            logger.debug "Got from #{path}"

            logger.data "(#{body.class}) #{body}"

            return body, response
          end
          alias :! :call # TODO: Remove deprecated actuator [Kelsey, Thu Oct 08 2015]

          def get(path)
            request = build_request(path)
            body, response = session.get(request)
            return body, response
          end

          def build_request(path)
            request = ::HTTP::Protocol::Request.new "GET", path

            set_event_store_accept_header(request)
            set_event_store_long_poll_header(request) if long_poll

            request
          end

          def media_type
            'application/vnd.eventstore.atom+json'
          end

          def set_event_store_accept_header(request)
            request['Accept'] = media_type
          end

          def set_event_store_long_poll_header(request)
            request['ES-LongPoll'] = Defaults.long_poll_duration
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
