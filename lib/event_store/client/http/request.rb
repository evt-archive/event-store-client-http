module EventStore
  module Client
    module HTTP
      module Request
        def self.included(cls)
          cls.class_exec do
            configure :request

            include Telemetry::Logger::Dependency

            extend Build

            dependency :logger, Telemetry::Logger
            dependency :session, EventSource::EventStore::HTTP::Session
          end
        end

        Virtual::Method.define self, :configure_dependencies

        def configure_session(session=nil)
          #EventSource::EventStore::HTTP::Session.configure self
          Session.configure self, session: session
        end

        module Build
          def build(session: nil)
            new.tap do |instance|
              instance.configure_dependencies
              instance.configure_session(session)
            end
          end
        end
      end
    end
  end
end
