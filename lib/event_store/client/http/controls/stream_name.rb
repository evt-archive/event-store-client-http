module EventStore
  module Client
    module HTTP
      module Controls
        module StreamName
          def self.get(category=nil)
            EventSource::EventStore::HTTP::Controls::StreamName.example(
              category: category
            )
          end

          def self.reference
            'someStream'
          end
        end
      end
    end
  end
end
