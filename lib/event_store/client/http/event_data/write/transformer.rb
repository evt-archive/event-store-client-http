module EventStore
  module Client
    module HTTP
      module EventData
        class Write
          module Transformer
            def self.json
              JSON
            end

            def self.raw_data(instance)
              {
                :event_id => instance.id,
                :event_type => instance.type,
                :data => instance.data,
                :metadata => instance.metadata
              }
            end

            module JSON
              def self.write(data)
                formatted_data = Casing::Camel.(data)
                ::JSON.pretty_generate formatted_data
              end
            end
          end
        end
      end
    end
  end
end
