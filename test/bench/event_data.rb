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

    begin
      event_data.assign_id
    rescue EventStore::Client::HTTP::EventData::IdentityError => error
    end

    assert error
  end

  test "Sequence is an alias for number" do
    event_data = EventStore::Client::HTTP::Controls::EventData::Read.example

    assert(event_data.sequence == event_data.number)
  end
end
