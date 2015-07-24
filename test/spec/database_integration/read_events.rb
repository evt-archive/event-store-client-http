require_relative './database_integration_init'

describe "Read Events" do

  stream_name = Fixtures::EventData.write 2, 'testEntryReader'

  event_reader = EventStore::Client::HTTP::EventReader.build stream_name, slice_size: 1

  events = []
  event_reader.each do |event|
    events << event
  end

  events.each do |event|
    logger(__FILE__).data event.inspect
  end

  specify "Events are read" do
    assert(events.length == 2)
  end
end