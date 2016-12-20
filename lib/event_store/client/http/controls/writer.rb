module EventStore
  module Client
    module HTTP
      module Controls
        module Writer
          def self.write(iterations=nil, stream_name=nil, data: nil, metadata: nil, stream_metadata: nil, verbatim_stream_name: nil)
            iterations ||= 1
            metadata = true if metadata.nil?
            verbatim_stream_name ||= false

            unless verbatim_stream_name
              stream_name = Controls::StreamName.get stream_name
            end

            path = "/streams/#{stream_name}"

            post = EventStore::Client::HTTP::Request::Post.build

            iterations.times do |iteration|
              iteration += 1

              id = ID.example(iteration)

              event_data = Controls::EventData::Batch.example(id, data: data, metadata: metadata)

              json_text = Serialize::Write.(event_data, :json)

              post_response = post.(json_text, path)
            end

            if stream_metadata
              EventStore::Client::HTTP::StreamMetadata::Update.(stream_name) do |metadata|
                metadata.update stream_metadata
              end
            end

            stream_name
          end
        end
      end
    end
  end
end
