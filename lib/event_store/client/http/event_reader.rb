module EventStore
  module Client
    module HTTP
      class EventReader
        configure :reader

        attr_reader :stream_name

        dependency :stream_reader, StreamReader
        dependency :logger, Telemetry::Logger

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

          new(stream_name, direction).tap do |instance|
            stream_reader.configure instance, stream_name, starting_position: starting_position, slice_size: slice_size, direction: direction, session: session

            Telemetry::Logger.configure instance
          end
        end

        def each(&action)
          logger.opt_trace "Enumerating events (Stream Name: #{stream_name})"

          each_slice(stream_reader, &action)

          logger.opt_debug "Completed enumerating events (Stream Name: #{stream_name})"
          nil
        end

        def each_slice(stream_reader, &action)
          stream_reader.each do |slice|
            read_slice(slice, &action)
          end
        end

        def read_slice(slice, &action)
          logger.opt_trace "Reading slice (Number of Entries: #{slice.length})"
          slice.each(direction) do |event_data|
            action.call event_data
          end
          logger.opt_debug "Read slice (Number of Entries: #{slice.length})"
        end

        module Assertions
          def self.extended(event_reader)
            stream_reader = event_reader.stream_reader

            stream_reader.extend stream_reader.class::Assertions
          end

          def session?(session)
            stream_reader.session? session
          end
        end
      end
    end
  end
end
