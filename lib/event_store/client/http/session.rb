module EventStore
  module Client
    module HTTP
      class Session
        initializer :session

        def method_missing(method_name, *arguments, &block)
          if respond_to_missing? method_name
            session.__send__ method_name, *arguments, &block
          else
            super
          end
        end

        def respond_to_missing?(method_name)
          session.respond_to? method_name
        end

        setting :host
        setting :port

        dependency :logger, Telemetry::Logger
        dependency :connection, Connection::Client

        def self.build(settings=nil, _namespace=nil, namespace: nil)
          unless _namespace.nil?
            logger.obsolete "Positional parameter for namespace is obsolete; it has been replaced by a keyword argument"
            namespace ||= _namespace
          end

          logger.opt_trace "Building HTTP session"

          session = EventSource::EventStore::HTTP::Session.build settings, namespace: namespace

          new(session).tap do |instance|
            Telemetry::Logger.configure instance

            settings ||= Settings.instance
            namespace = Array(namespace)

            settings.set(instance, *namespace)

            Connection::Client.configure instance, instance.host, instance.port, :reconnect => :closed

            logger.opt_debug "Built HTTP session (Host: #{instance.host}, Port: #{instance.port})"
          end
        end

        def self.configure(receiver, session: nil, attr_name: nil)
          attr_name ||= :session

          instance = session || build
          receiver.public_send "#{attr_name}=", instance
          instance
        end

        def build_uri(path)
          uri = URI(path)

          if uri.absolute?
            uri
          else
            URI::HTTP.build(
              :host => host,
              :port => port,
              :path => uri.path,
              :query => uri.query
            )
          end
        end

        def self.logger
          @logger ||= Telemetry::Logger.get self
        end
      end
    end
  end
end
