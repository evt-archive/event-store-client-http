module EventStore
  module Client
    module HTTP
      module EventData
        class Read < EventSource::EventData::Read
          attribute :number
          attribute :position
          attribute :created_time
          attribute :links
          
          alias :sequence :number

          def to_h
            super.update(
              :type => type,
              :data => data,
              :metadata => metadata,
              :stream_name => stream_name
            )
          end
        end
      end
    end
  end
end
