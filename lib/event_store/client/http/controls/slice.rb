module EventStore
  module Client
    module HTTP
      module Controls
        module Slice
          def self.data(stream_name=nil, count: nil)
            count ||= 2
            stream_name ||= 'someStream'

            entries = count.times.reverse_each.map do |number|
              EventData.data(number, position: number)
            end

            {
              :links => [
                {
                  :uri => "http://localhost:2113/streams/#{stream_name}/#{count}/forward/#{count}",
                  :relation => "next"
                }
              ],
              :entries => entries
            }
          end

          module JSON
            def self.text(count: nil)
              raw_data = Slice.data count: count

              formatted_data = Casing::Camel.(raw_data, symbol_to_string: true)

              ::JSON.pretty_generate formatted_data
            end
          end
        end
      end
    end
  end
end
