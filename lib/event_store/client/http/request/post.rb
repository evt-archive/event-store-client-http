module EventStore
  module Client
    module HTTP
      module Request
        class Post
          include Telemetry::Logger::Dependency

          dependency :session, EventSource::EventStore::HTTP::Session

          def self.build(session: nil)
            instance = new
            Session.configure instance, session: session
            instance
          end

          def self.configure(receiver, session: nil)
            attr_name ||= :request

            instance = build session: session
            receiver.public_send "#{attr_name}=", instance
            instance
          end

          def call(data, path, expected_version: nil)
            log_attributes = "Path: #{path}, ExpectedVersion: #{expected_version.inspect}"

            logger.opt_trace "Issuing POST (#{log_attributes})"
            logger.opt_data data

            headers = self.headers(expected_version)

            reason_phrase = nil

            request = Net::HTTP::Post.new path, headers
            request['Content-Type'] = media_type
            request.body = data

            response = session.(request)

            status_code = response.code.to_i
            reason_phrase = response.message

            log_attributes << ", StatusCode: #{status_code}, ReasonPhrase: #{reason_phrase}"

            if status_code == 400 && reason_phrase == 'Wrong expected EventNumber'
              error_message = "Wrong expected version number (#{log_attributes})"
              logger.error error_message
              raise ExpectedVersionError, error_message
            end

            if status_code == 500 && reason_phrase == 'Write timeout'
              error_message = "Write timeout (#{log_attributes})"
              logger.error error_message
              raise WriteTimeoutError, error_message
            end

            if status_code != 201
              error_message = "Post command failed (#{log_attributes})"
              logger.error error_message
              raise Error, error_message
            end

            logger.opt_debug "Issued POST (#{log_attributes})"

            status_code
          end
          alias :! :call # TODO: Remove deprecated actuator [Kelsey, Thu Oct 08 2015]

          def headers(expected_version=nil)
            headers = {}

            unless expected_version.nil?
              expected_version = -1 if expected_version == self.class.no_stream_version
              set_expected_version_header(headers, expected_version)
            end

            headers
          end

          def self.no_stream_version
            :no_stream
          end

          def media_type
            'application/vnd.eventstore.events+json'
          end

          def set_expected_version_header(request, expected_version)
            request['ES-ExpectedVersion'] = expected_version.to_s
          end

          Error = EventSource::EventStore::HTTP::Request::Post::Error
          ExpectedVersionError = EventSource::EventStore::HTTP::Request::Post::ExpectedVersionError
          WriteTimeoutError = EventSource::EventStore::HTTP::Request::Post::WriteTimeoutError
        end
      end
    end
  end
end
