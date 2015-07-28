require_relative './subscription_init'

stream_name = File.read "tmp/stream_name"

unless stream_name
  raise "Stream name file is missing (tmp/stream_name). It is created by the write_events_periodically.rb script."
end

event_reader = EventStore::Client::HTTP::EventReader.build stream_name, slice_size: 1

event_reader.subscribe do |event|
  logger(__FILE__).info event.inspect
end
