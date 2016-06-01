module EventStore
  module Client
    module HTTP
      class Slice
        include Schema::DataStructure

        attribute :entries, Array
        attribute :links, Links

        def each(direction, &action)
          if direction == :forward
            method_name = :reverse_each
          else
            method_name = :each
          end

          entries.public_send method_name do |entry|
            action.call entry
          end
        end

        def length
          entries.length
        end

        def next_uri(direction)
          if direction == :forward
            links.next_uri
          else
            links.previous_uri
          end
        end
      end
    end
  end
end
