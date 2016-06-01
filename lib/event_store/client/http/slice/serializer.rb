module EventStore
  module Client
    module HTTP
      class Slice
        module Serializer
          def self.json
            JSON
          end

          def self.instance(data)
            links = self.links data[:links]

            entries = self.entries data[:entries]

            Slice.build :entries => entries, :links => links
          end

          def self.entries(entry_datum)
            entry_datum.map do |entry_data|
              event_data entry_data
            end
          end

          def self.event_data(data)
            links = EventData::Read::Serializer::Links.new

            data[:links].to_a.each do |link_data|
              links.edit_uri = link_data[:uri] if link_data[:relation] == 'edit'
            end

            instance = EventData::Read.build(
              :created_time => data[:updated],
              :data => data[:data],
              :links => links,
              :metadata => data[:meta_data],
              :number => data[:event_number],
              :position => data[:position_event_number],
              :stream_name => data[:stream_id],
              :type => data[:event_type]
            )

            instance
          end

          def self.links(links_data)
            links = Links.new

            links_data.each do |link_data|
              if link_data[:relation] == 'previous'
                links.next_uri = link_data[:uri]
              elsif link_data[:relation] == 'next'
                links.previous_uri = link_data[:uri]
              end
            end

            links
          end

          module JSON
            def self.deserialize(text)
              formatted_data = ::JSON.parse text, symbolize_names: true
              raw_data = Casing::Underscore.(formatted_data)

              raw_data[:entries].each do |entry|
                event_data_text = entry[:data]
                entry[:data] = unpack_serialized_value event_data_text

                metadata_text = entry[:meta_data]
                if metadata_text
                  entry[:meta_data] = unpack_serialized_value metadata_text
                end
              end

              raw_data
            end

            def self.unpack_serialized_value(text)
              data = ::JSON.parse text, symbolize_names: true
              Casing::Underscore.(data)
            end
          end
        end
      end
    end
  end
end
