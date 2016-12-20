module EventStore
  module Client
    module HTTP
      module EventData
        class Read
          module Transformer
            def self.json
              JSON
            end

            def self.instance(data)
              content = data[:content] || {}

              links = Links.new

              data[:links].to_a.each do |link_data|
                links.edit_uri = link_data[:uri] if link_data[:relation] == 'edit'
              end

              instance = Read.build(
                :created_time => data[:updated],
                :data => content[:data],
                :links => links,
                :number => content[:event_number],
                :position => data[:position_event_number],
                :stream_name => content[:event_stream_id],
                :type => content[:event_type]
              )

              unless content[:metadata] == ''
                instance.metadata = content[:metadata]
              end

              instance
            end

            module JSON
              def self.read(text)
                data = ::JSON.parse text, :symbolize_names => true
                Casing::Underscore.(data)
              end
            end
          end
        end
      end
    end
  end
end
