module EventStore
  module Client
    module HTTP
      class Slice
        module Transformer
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
            links = EventData::Read::Links.new

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
            class ObjectClass < Hash
              def []=(raw_key, value)
                key = key_cache[raw_key]

                super key, value
              end

              def key_cache
                @@key_cache ||= Hash.new do |cache, raw_key|
                  cache[raw_key] = Casing::Underscore.(raw_key).to_sym
                end
              end
            end

            def self.read(text)
              raw_data = ::JSON.parse text, object_class: ObjectClass

              raw_data[:entries].each do |entry|
                event_data_text = entry[:data]
                entry[:data] = ::JSON.parse event_data_text, object_class: ObjectClass

                metadata_text = entry[:meta_data]
                if metadata_text && !metadata_text.empty?
                  entry[:meta_data] = ::JSON.parse metadata_text, object_class: ObjectClass
                end
              end

              raw_data
            end
          end
        end
      end
    end
  end
end
