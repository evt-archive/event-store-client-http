module EventStore
  module Client
    module HTTP
      module Controls
        module EventData
          module Read
            def self.example(number=nil, **arguments)
              data = self.data(number, **arguments)

              Transform::Read.instance data, Client::HTTP::EventData::Read
            end

            def self.data(number=nil, type: nil, data: nil, metadata: nil, stream_name: nil, position: nil)
              reference_time = Time.example

              number ||= 0
              type ||= EventData.type
              data ||= EventData.data
              metadata = true if metadata.nil?
              stream_name ||= StreamName.reference
              position ||= number

              edit_link = Links::Edit.example stream_name: stream_name, number: number

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
                    :uri => edit_link,
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

            module Links
              module Edit
                def self.example(stream_name: nil, number: nil)
                  number ||= 0
                  stream_name ||= StreamName.reference

                  "http://#{IPAddress.example}:2113/streams/#{stream_name}/#{number}"
                end
              end

              IPAddress = EventSource::EventStore::HTTP::Controls::IPAddress
            end
          end
        end
      end
    end
  end
end
