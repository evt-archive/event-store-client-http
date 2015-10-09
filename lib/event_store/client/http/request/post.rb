module EventStore
  module Client
    module HTTP
      module Request
        class Post
          class ExpectedVersionError < RuntimeError; end

          include Request

          def call(data, path, expected_version: nil)
            logger.trace "Posting to #{path}"
            logger.data data

            response = post(data, path, expected_version)

            logger.info "POST Response\nPath: #{path}\nStatus: #{response.status_code} #{response.reason_phrase.rstrip}"
            logger.debug "Posted to #{path}"

            response
          end
          alias :! :call # TODO: Remove deprecated actuator [Kelsey, Thu Oct 08 2015]

          def post(data, path, expected_version=nil)
            request = build_request(path, expected_version)

            response = session.request(request, request_body: data)

            if "#{response.status_code} #{response.reason_phrase}" == "400 Wrong expected EventNumber"
              raise ExpectedVersionError, "Wrong expected version number: #{expected_version} (Path: #{path})"
            end

            response
          end

          def build_request(path, expected_version=nil)
            logger.trace "Building request (Path: #{path}, Expected Version: #{!!expected_version ? expected_version : '(none)'}"
            request = ::HTTP::Protocol::Request.new("POST", path)

            set_event_store_content_type_header(request)
            set_expected_version_header(request, expected_version) if !!expected_version

            logger.debug "Built request (Path: #{path}, Expected Version: #{!!expected_version ? expected_version : '(none)'}"

            request
          end

          def media_type
            'application/vnd.eventstore.events+json'
          end

          def set_event_store_content_type_header(request)
            request['Content-Type'] = media_type
          end

          def set_expected_version_header(request, expected_version)
            request['ES-ExpectedVersion'] = expected_version
          end
        end
      end
    end
  end
end
