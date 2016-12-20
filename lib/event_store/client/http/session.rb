module EventStore
  module Client
    module HTTP
      class Session
        def self.build(settings=nil, _namespace=nil, namespace: nil)
          unless _namespace.nil?
            logger.obsolete "Positional parameter for namespace is obsolete; it has been replaced by a keyword argument"
            namespace ||= _namespace
          end

          EventSource::EventStore::HTTP::Session.build settings, namespace: namespace
        end

        def self.configure(receiver, session: nil, attr_name: nil)
          EventSource::EventStore::HTTP::Session.configure receiver, session: session, attr_name: attr_name
        end
      end
    end
  end
end
