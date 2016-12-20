module EventStore
  module Client
    module HTTP
      module EventData
        class Read
          include EventData

          attribute :number, Integer
          attribute :position, Integer
          attribute :stream_name, String
          attribute :created_time, String
          attribute :links, Links
          
          alias :sequence :number
        end
      end
    end
  end
end
