module EventStore
  module Client
    module HTTP
      module EventData
        def self.included(cls)
          cls.class_exec do
            include EventSource::EventData
          end
        end

        Virtual::Method.define self, :configure

        def digest
          "Type: #{type}"
        end

        IdentityError = Class.new RuntimeError
      end
    end
  end
end
