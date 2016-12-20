require_relative 'bench_init'

context "Stream Slice" do
  json_text = EventStore::Client::HTTP::Controls::Slice::JSON.text
  slice = Transform::Read.(json_text, EventStore::Client::HTTP::Slice, :json)

  context "Entries" do
    test "Data" do
      assert slice.entries[0].data.key?(:some_attribute)
      assert slice.entries[1].data.key?(:some_attribute)
    end

    test "Metadata" do
      assert slice.entries[0].metadata.key?(:meta_attribute)
      assert slice.entries[1].metadata.key?(:meta_attribute)
    end

    test "Position" do
      assert slice.entries[0].position == 1
      assert slice.entries[1].position == 0
    end
  end

  test "Next URI" do
    assert slice.links.previous_uri.match(%r{/streams/someStream/2/forward/2$})
  end
end
