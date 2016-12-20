module EventStore
  module Client
    module HTTP
      module EventData
        class Write < EventSource::EventData::Write
          attribute :id

          dependency :uuid, Identifier::UUID::Random

          def configure
            Identifier::UUID::Random.configure self
          end

          def assign_id
            unless id.nil?
              raise IdentityError, "ID is already assigned (ID: #{id})"
            end

            self.id = uuid.get
          end
        end
      end
    end
  end
end
