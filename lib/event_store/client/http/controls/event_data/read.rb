module EventStore
  module Client
    module HTTP
      module Controls
        module EventData
          module Read
            def self.example(number=nil, **arguments)
              data = self.data(number, *arguments)

              Serialize::Read.instance data, Client::HTTP::EventData::Read
            end

            def self.data(number=nil, type: nil, data: nil, metadata: nil, stream_name: nil, position: nil)
              reference_time = Time.example

              number ||= 0
              type ||= Type.example
              data ||= Data.example
              metadata = true if metadata.nil?
              stream_name ||= StreamName.reference
              position ||= number

              data = {
                :updated => reference_time,
                :content => {
                  :event_type => type,
                  :event_number => number,
                  :event_stream_id => stream_name,
                  :data => data
                },
                :position_event_number => position,
                :links => [
                  {
                    :uri => "http://localhost:2113/streams/#{stream_name}/#{number}",
                    :relation => 'edit'
                  }
                ]
              }

              metadata = Metadata.data if metadata == true
              data[:content][:metadata] = metadata if metadata

              data
            end

            module JSON
              def self.text(number=nil, **arguments)
                raw_data = Read.data number, **arguments

                formatted_data = Casing::Camel.(raw_data, symbol_to_string: true)

                ::JSON.pretty_generate formatted_data
              end
            end
          end
        end
      end
    end
  end
end
