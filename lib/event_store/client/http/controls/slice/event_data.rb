module EventStore
  module Client
    module HTTP
      module Controls
        module Slice
          module EventData
            def self.data(number=nil, metadata: nil, position: nil)
              metadata = true if metadata.nil?
              number ||= 0
              position ||= number

              metadata = Controls::EventData::Metadata::JSON.text
              stream_name = StreamName.reference
              time = ::Controls::Time.reference
              type = 'SomeEvent'

              payload = ::JSON.generate(
                :some_attribute => 'some value',
                :some_time => time
              )

              data = {
                :updated => time,
                :event_type => type,
                :event_number => number,
                :stream_id => stream_name,
                :data => payload,
                :position_event_number => position,
                :links => [
                  {
                    :uri => "http://localhost:2113/streams/#{stream_name}/#{number}",
                    :relation => 'edit'
                  }
                ]
              }

              if metadata
                data[:meta_data] = metadata
              end

              data
            end
          end
        end
      end
    end
  end
end
