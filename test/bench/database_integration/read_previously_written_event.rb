require_relative '../bench_init'

context "Reading back events previously written to the database" do
  context do
    data = EventStore::Client::HTTP::Controls::EventData.data
    metadata = EventStore::Client::HTTP::Controls::EventData::Metadata.data

    stream_name = EventStore::Client::HTTP::Controls::Writer.write data: data, metadata: metadata

    event_data = nil

    EventStore::Client::HTTP::Reader.build(stream_name).each do |_event_data|
      event_data = _event_data
    end

    test "Event type" do
      assert event_data.type == EventStore::Client::HTTP::Controls::EventData.type
    end

    test "Event data payload" do
      assert event_data.data == data
    end

    test "Event metadata" do
      assert event_data.metadata == metadata
    end

    test "Event number within stream" do
      assert event_data.number == 0
    end

    test "Event position within read" do
      assert event_data.position == 0
    end

    test "Stream Name" do
      assert event_data.stream_name == stream_name
    end
  end

  context "Event does not include metadata" do
    stream_name = EventStore::Client::HTTP::Controls::Writer.write metadata: false

    event_data = nil

    EventStore::Client::HTTP::Reader.build(stream_name).each do |_event_data|
      event_data = _event_data
    end

    test "Metadata is not present in event data read back from the database" do
      assert event_data.metadata.nil?
    end
  end
end
