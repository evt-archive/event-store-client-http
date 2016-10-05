module EventStore
  module Client
    module HTTP
      module Controls
        module EventData
          module Metadata
            def self.example
              {
                some_meta_attribute: 'some meta value'
              }
            end

            def self.data
              example
            end

            module JSON
              def self.data
                {
                  'someMetaAttribute' => 'some meta value'
                }
              end

              def self.text
                ::JSON.generate data
              end
            end
          end
        end
      end
    end
  end
end
