module EventStore
  module Client
    module HTTP
      module Controls
        module EventData
          def self.type
            EventSource::EventStore::HTTP::Controls::EventData.type
          end

          def self.data
            EventSource::EventStore::HTTP::Controls::EventData.data
          end
        end
      end
    end
  end
end
