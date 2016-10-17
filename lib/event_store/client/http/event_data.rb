module EventStore
  module Client
    module HTTP
      module EventData
        class IdentityError < RuntimeError; end

        def self.included(cls)
          cls.class_exec do
            include Schema::DataStructure

            dependency :uuid, Identifier::UUID::Random
            dependency :logger, Telemetry::Logger

            attribute :type
            attribute :data
            attribute :metadata

            prepend Configure

            virtual :configure
          end
        end

        def digest
          "Type: #{type}"
        end

        module Configure
          def configure
            Identifier::UUID::Random.configure self
            Telemetry::Logger.configure self

            super
          end
        end
      end
    end
  end
end
