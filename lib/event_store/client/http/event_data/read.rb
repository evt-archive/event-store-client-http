module EventStore
  module Client
    module HTTP
      module EventData
        class Read < EventSource::EventData::Read
          attribute :number
          attribute :position
          attribute :stream_name
          attribute :created_time
          attribute :links
          
          alias :sequence :number
        end
      end
    end
  end
end
