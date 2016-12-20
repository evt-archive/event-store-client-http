module EventStore
  module Client
    module HTTP
      module Session
        def self.build(settings=nil, _namespace=nil, namespace: nil)
          unless _namespace.nil?
            logger = Telemetry::Logger.get(self)
            logger.obsolete "Positional parameter for namespace is obsolete; it has been replaced by a keyword argument"
            namespace ||= _namespace
          end

          settings ||= Settings.instance

          EventSource::EventStore::HTTP::Session.build settings, namespace: namespace
        end

        def self.configure(receiver, session: nil, attr_name: nil)
          settings = Settings.instance

          EventSource::EventStore::HTTP::Session.configure receiver, settings, session: session, attr_name: attr_name
        end

        module Substitute
          def self.build
            SubstAttr::Substitute.build EventSource::EventStore::HTTP::Session
          end
        end
      end
    end
  end
end
