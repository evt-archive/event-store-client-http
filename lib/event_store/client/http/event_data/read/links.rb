module EventStore
  module Client
    module HTTP
      module EventData
        class Read
          class Links
            include Schema::DataStructure

            attribute :edit_uri
          end
        end
      end
    end
  end
end
