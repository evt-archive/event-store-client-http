require_relative 'bench_init'

context "Event Data Serialization" do
  write_event_data = EventStore::Client::HTTP::Controls::EventData::Write.example

  data = write_event_data.data
  metadata = write_event_data.metadata

  test "Converts to raw data" do
    control_raw_data = EventStore::Client::HTTP::Controls::EventData::Write.data data: data, metadata: metadata

    raw_data = Serialize::Write.raw_data write_event_data

    assert raw_data == control_raw_data
  end

  test "Converts to JSON" do
    control_text = EventStore::Client::HTTP::Controls::EventData::Write::JSON.text data: data, metadata: metadata

    json_text = Serialize::Write.(write_event_data, :json)

    assert json_text == control_text
  end
end
