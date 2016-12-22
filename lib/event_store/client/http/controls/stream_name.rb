module EventStore
  module Client
    module HTTP
      module Controls
        module StreamName
          def self.get(category=nil, id: nil, randomize_category: nil)
            EventSource::EventStore::HTTP::Controls::StreamName.example(
              category: category,
              id: id,
              randomize_category: randomize_category
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
