module EventStore
  module Client
    module HTTP
      module Controls
        module Slice
          module JSON
            def self.data(stream_name=nil)
              stream_name ||= 'someStream'

              entries = [
                EventData::Read.data(1, position: 1),
                EventData::Read.data(0, position: 0)
              ]

              {
                :links => [
                  {
                    :uri => "http://localhost:2113/streams/#{stream_name}/2/forward/2",
                    :relation => "previous"
                  }
                ],
                :entries => entries
              }
            end

            def self.text
              raw_data = data

              formatted_data = Casing::Camel.(raw_data, symbol_to_string: true)

              ::JSON.generate formatted_data
            end
          end
        end
      end
    end
  end
end
