require_relative '../bench_init'

context "Write Event" do
  stream_name = EventStore::Client::HTTP::Controls::StreamName.get 'testEventWriter'
  path = "/streams/#{stream_name}"

  writer = EventStore::Client::HTTP::EventWriter.build

  event_data = EventStore::Client::HTTP::Controls::EventData::Write.example

  writer.write event_data, stream_name

  get = EventStore::Client::HTTP::Request::Get.build
  body_text, get_response = get.("#{path}/0")

  read_data = Serialize::Read.(body_text, EventStore::Client::HTTP::EventData::Read, :json)

  __logger.data read_data.inspect

  context "Event is written" do
    test "Stream Name" do
      assert(read_data.stream_name == stream_name)
    end

    test "Number" do
      assert(read_data.number == 0)
    end

    test "Data" do
      assert read_data.data == event_data.data
    end

    test "Metadata" do
      assert read_data.metadata == event_data.metadata
    end
  end
end
