require_relative '../../bench_init'

context "Setting metadata for stream with no prior metadata" do
  stream_name = EventStore::Client::HTTP::Controls::Writer.write
  control_metadata = EventStore::Client::HTTP::Controls::StreamMetadata.data

  update_metadata = EventStore::Client::HTTP::StreamMetadata::Update.build stream_name

  event_data, status_code = update_metadata.() do |metadata|
    metadata.update control_metadata
  end

  test "Metadata is written as the data portion of an event" do
    assert event_data.data == control_metadata
  end

  test "Event type is set" do
    assert event_data.type == 'MetadataUpdated'
  end

  test "EventStore accepts the submitted metadata" do
    assert status_code == 201
  end
end
