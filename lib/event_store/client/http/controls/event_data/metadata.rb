module EventStore
  module Client
    module HTTP
      module Controls
        module EventData
          module Metadata
            def self.data
              EventSource::EventStore::HTTP::Controls::EventData::Metadata.data
            end

            module JSON
              def self.text
                data = Metadata.data

                { 'metaAttribute' => data[:meta_attribute] }

                ::JSON.generate data
              end
            end
          end
        end
      end
    end
  end
end
