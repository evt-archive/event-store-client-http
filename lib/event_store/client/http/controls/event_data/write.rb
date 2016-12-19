module EventStore
  module Client
    module HTTP
      module Controls
        module EventData
          module Write
            def self.example(id=nil, i: nil, type: nil, data: nil, metadata: nil)
              id ||= ID.example i, sample: false
              type ||= EventData.type
              data ||= EventData.data
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
              def self.text(data: nil, metadata: nil)
                event_data = Write.example data: data, metadata: metadata

                Serialize::Write.(event_data, :json)
              end
            end
          end
        end
      end
    end
  end
end
