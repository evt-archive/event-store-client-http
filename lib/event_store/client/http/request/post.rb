module EventStore
  module Client
    module HTTP
      module Request
        module Post
          def self.build(session: nil)
            session ||= Session.build

            EventSource::EventStore::HTTP::Request::Post.build session: session
          end

          def self.configure(receiver, session: nil, attr_name: nil)
            session ||= Session.build

            EventSource::EventStore::HTTP::Request::Post.configure(
              receiver,
              session: session,
              attr_name: attr_name
            )
          end

          Error = EventSource::EventStore::HTTP::Request::Post::Error
          ExpectedVersionError = EventSource::EventStore::HTTP::Request::Post::ExpectedVersionError
          WriteTimeoutError = EventSource::EventStore::HTTP::Request::Post::WriteTimeoutError
        end
      end
    end
  end
end
