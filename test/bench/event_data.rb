require_relative 'bench_init'

context "Event Data" do
  test "Assign ID" do
    event_data = EventStore::Client::HTTP::EventData::Write.build
    event_data.assign_id
    assert !event_data.id.nil?
  end

  test "ID can't be re-assigned" do
    event_data = EventStore::Client::HTTP::EventData::Write.build
    event_data.assign_id

    assert proc { event_data.assign_id } do
      raises_error? EventStore::Client::HTTP::EventData::IdentityError
    end
  end

  test "Sequence is an alias for number" do
    event_data = EventStore::Client::HTTP::Controls::EventData::Read.example

    assert(event_data.sequence == event_data.number)
  end

  context "Hash conversion" do
    context "Read event data" do
      event_data = EventStore::Client::HTTP::Controls::EventData::Read.example

      hash = event_data.to_h

      test "Type attribute" do
        assert hash[:type] == event_data.type
      end

      test "Data attribute" do
        assert hash[:data] == event_data.data
      end

      test "Metadata attribute" do
        assert hash[:metadata] == event_data.metadata
      end

      test "Number attribute" do
        assert hash[:number] == event_data.number
      end

      test "Position attribute" do
        assert hash[:position] == event_data.position
      end

      test "Created time attribute" do
        assert hash[:created_time] == event_data.created_time
      end

      test "Links attribute" do
        assert hash[:links] == event_data.links
      end

      test "Stream name attribute" do
        assert hash[:stream_name] == event_data.stream_name
      end
    end

    context "Write event data" do
      event_data = EventStore::Client::HTTP::Controls::EventData::Write.example

      hash = event_data.to_h

      test "Type attribute" do
        assert hash[:type] == event_data.type
      end

      test "Data attribute" do
        assert hash[:data] == event_data.data
      end

      test "Metadata attribute" do
        assert hash[:metadata] == event_data.metadata
      end

      test "ID attribute" do
        assert hash[:id] == event_data.id
      end
    end
  end
end
