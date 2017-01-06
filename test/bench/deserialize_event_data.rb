require_relative 'bench_init'

context "Deserialized Entry" do
  json_text = EventStore::Client::HTTP::Controls::EventData::Read::JSON.text
  event_data = Transform::Read.(json_text, EventStore::Client::HTTP::EventData::Read, :json)

  reference_time = EventStore::Client::HTTP::Controls::Time.example

  test "Type" do
    assert(event_data.type == 'SomeType')
  end

  test "Number" do
    assert(event_data.number == 0)
  end

  test "Stream Name" do
    assert(event_data.stream_name == 'someStream')
  end

  test "Created Time" do
    assert(event_data.created_time == reference_time)
  end

  test "Data" do
    assert(event_data.data.key?(:attribute))
  end

  test "Metadata" do
    assert(event_data.metadata.key?(:meta_attribute))
  end

  context "Links" do
    test "Edit" do
      edit_uri = event_data.links.edit_uri
      assert(edit_uri == 'http://127.0.0.1:2113/streams/someStream/0')
    end
  end
end
