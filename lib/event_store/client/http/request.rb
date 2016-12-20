module EventStore
  module Client
    module HTTP
      module Request
        def self.included(cls)
          cls.class_exec do
            configure :request

            include Telemetry::Logger::Dependency

            extend Build

            dependency :session, EventSource::EventStore::HTTP::Session
          end
        end

        module Build
          def build(session: nil)
            instance = new
            EventSource::EventStore::HTTP::Session.configure instance, session: session
            instance
          end
        end
      end
    end
  end
end
