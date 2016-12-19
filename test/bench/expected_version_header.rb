require_relative 'bench_init'

context "Expected Version" do
  expected_version_header = EventStore::Client::HTTP::Controls::ExpectedVersionHeader::FieldName.example

  context "When not set" do
    test "Does not set the ES-ExpectedVersion header" do
      post = EventStore::Client::HTTP::Request::Post.new

      headers = post.headers

      assert headers[expected_version_header].nil?
    end
  end

  context "When set" do
    test "Sets the ES-ExpectedVersion header" do
      post = EventStore::Client::HTTP::Request::Post.new

      headers = post.headers(1)

      assert headers[expected_version_header] == '1'
    end
  end

  context "When set to :no_stream" do
    test "Sets the ES-ExpectedVersion header to -1" do
      post = EventStore::Client::HTTP::Request::Post.new

      expected_version = EventStore::Client::HTTP::Request::Post.no_stream_version
      expected_header_value = EventStore::Client::HTTP::Controls::ExpectedVersionHeader::NoStream.example

      headers = post.headers(expected_version)

      assert headers[expected_version_header] == expected_header_value.to_s
    end
  end
end
