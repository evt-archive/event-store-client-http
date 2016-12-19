require_relative '../bench_init'

context "Writing the Expected Version Number" do
  context "Right Version" do
    stream_name = EventStore::Client::HTTP::Controls::StreamName.get 'testWrongVersion'

    writer = EventStore::Client::HTTP::EventWriter.build

    event_data_1 = EventStore::Client::HTTP::Controls::EventData::Write.example
    writer.write event_data_1, stream_name

    event_data_2 = EventStore::Client::HTTP::Controls::EventData::Write.example

    test "Succeeds" do
      writer.write event_data_2, stream_name, expected_version: 0
    end
  end

  context "Wrong Version" do
    stream_name = EventStore::Client::HTTP::Controls::StreamName.get 'testWrongVersion'

    writer = EventStore::Client::HTTP::EventWriter.build

    event_data_1 = EventStore::Client::HTTP::Controls::EventData::Write.example
    writer.write event_data_1, stream_name

    event_data_2 = EventStore::Client::HTTP::Controls::EventData::Write.example

    test "Fails" do
      assert proc { writer.write event_data_2, stream_name, expected_version: 11 } do
        raises_error? EventStore::Client::HTTP::Request::Post::ExpectedVersionError
      end
    end
  end
end
