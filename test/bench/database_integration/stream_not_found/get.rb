require_relative '../../bench_init'

context "Get a Stream that Doesn't Exist" do
  stream_name = EventStore::Client::HTTP::Controls::StreamName.get "testNotFound"
  path = "/streams/#{stream_name}"

  get = EventStore::Client::HTTP::Request::Get.build
  body_text, status_code = get.(path)

  test "Response status is 404 Not Found" do
    assert(status_code == 404)
  end

  test "Body is nil" do
    assert(body_text.nil?)
  end
end
