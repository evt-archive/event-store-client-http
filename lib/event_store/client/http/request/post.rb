module EventStore
  module Client
    module HTTP
      module Request
        module Post
          Error = EventSource::EventStore::HTTP::Request::Post::Error
          ExpectedVersionError = EventSource::ExpectedVersion::Error
          WriteTimeoutError = EventSource::EventStore::HTTP::Request::Post::WriteTimeoutError
        end
      end
    end
  end
end
