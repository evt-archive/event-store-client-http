module EventStore
  module Client
    module HTTP
      module Request
        module Get
          def self.build(session: nil)
            session ||= Session.build

            EventSource::EventStore::HTTP::Request::Get.build session: session
          end

          def self.configure(receiver, session: nil, attr_name: nil)
            session ||= Session.build

            EventSource::EventStore::HTTP::Request::Get.configure(
              receiver,
              session: session,
              attr_name: attr_name
            )
          end
        end
      end
    end
  end
end
