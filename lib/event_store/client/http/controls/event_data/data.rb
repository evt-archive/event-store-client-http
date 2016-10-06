module EventStore
  module Client
    module HTTP
      module Controls
        module EventData
          module Data
            def self.example(time: nil)
              time ||= Time.example

              {
                :some_attribute => 'some value',
                :some_time => time
              }
            end

            module JSON
              def self.data(time: nil)
                data = Data.example time: time

                Casing::Camel.(data, symbol_to_string: true)
              end
            end
          end
        end
      end
    end
  end
end
