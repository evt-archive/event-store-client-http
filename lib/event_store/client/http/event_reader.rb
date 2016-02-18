module EventStore
  module Client
    module HTTP
      class EventReader
        attr_reader :stream_name

        dependency :request, EventStore::Client::HTTP::Request::Get
        dependency :stream_reader, StreamReader
        dependency :logger, Telemetry::Logger

        ## TODO [backward] remove, probably not needed on this object. it's passed on
        # def starting_position
        #   @starting_position ||= Defaults.starting_position
        # end

        # def slice_size
        #   @slice_size ||= Defaults.slice_size
        # end

        def direction
          @direction ||= StreamReader::Defaults.direction
        end

        def initialize(stream_name, direction=nil)
          @stream_name = stream_name
          @direction = direction
        end

        def self.build(stream_name, starting_position: nil, slice_size: nil, direction: nil, session: nil)
          slice_size ||= StreamReader::Defaults.slice_size
          direction ||= StreamReader::Defaults.direction
          starting_position ||= StreamReader::Defaults.starting_position(direction)

          logger.trace "Building event reader (Stream Name: #{stream_name}, Starting Position: #{starting_position}, Slice Size: #{slice_size}, Direction: #{direction})"

          new(stream_name, direction).tap do |instance|
            EventStore::Client::HTTP::Request::Get.configure instance, session: session

            stream_reader.configure instance, stream_name, starting_position: starting_position, slice_size: slice_size, direction: direction, session: session

            Telemetry::Logger.configure instance
            logger.debug "Built event reader (Stream Name: #{stream_name}, Starting Position: #{starting_position}, Slice Size: #{slice_size}, Direction: #{direction})"
          end
        end

        def self.configure(receiver, stream_name, starting_position: nil, slice_size: nil, session: nil)
          instance = build stream_name, starting_position: starting_position, slice_size: slice_size, session: session
          receiver.reader = instance
          instance
        end

        def each(&action)
          logger.trace "Enumerating events (Stream Name: #{stream_name})"

          each_slice(stream_reader, &action)

          logger.debug "Completed enumerating events (Stream Name: #{stream_name})"
          nil
        end

        def each_slice(stream_reader, &action)
          stream_reader.each do |slice|
            read_slice(slice, &action)
          end
        end

        def read_slice(slice, &action)
          slice.each(direction) do |event_json_data|
            entry = get_entry(event_json_data)
            action.call entry
          end
        end

        def get_entry(event_json_data)
          json_text = get_json_text(event_json_data)
          parse_entry(json_text)
        end

        def get_json_text(event_json_data)
          uri = entry_link(event_json_data)
          body_text, _ = request.(uri)
          body_text
        end

        def parse_entry(json_text)
          EventData::Read.parse json_text
        end

        def entry_link(event_json_data)
          event_json_data['links'].map do |link|
            link['uri'] if link['relation'] == 'edit'
          end.compact.first
        end

        def deserialize_entry(event_json_data)
          event_json_data
        end

        def self.logger
          Telemetry::Logger.get self
        end
      end
    end
  end
end
