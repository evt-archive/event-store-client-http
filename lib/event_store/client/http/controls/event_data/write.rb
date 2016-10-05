module EventStore
  module Client
    module HTTP
      module Controls
        module EventData
          module Write
            def self.example(id=nil, i: nil, type: nil, data: nil, metadata: nil)
              id ||= ID.example i, sample: false
              type ||= Type.example
              data ||= Data.example
              metadata = true if metadata.nil?

              event_data = EventStore::Client::HTTP::EventData::Write.build
              event_data.id = id
              event_data.type = type
              event_data.data = data

              metadata = Metadata.data if metadata == true
              event_data.metadata = metadata if metadata

              event_data
            end

            def self.data(id=nil, **arguments)
              event_data = self.example id, **arguments

              Serialize::Write.raw_data event_data
            end

            module JSON
              def self.text
                event_data = Write.example

                Serialize::Write.(event_data, :json)
              end
            end
          end
        end
      end
    end
  end
end
