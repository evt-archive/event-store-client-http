require_relative '../bench_init'

context "Posting event data" do
  stream_name = EventStore::Client::HTTP::Controls::StreamName.get "testPostAndGet"
  path = "/streams/#{stream_name}"

  data = EventStore::Client::HTTP::Controls::EventData::Batch::JSON.text

  post = EventStore::Client::HTTP::Request::Post.build
  post_status_code = post.(path, data)

  get = EventStore::Client::HTTP::Request::Get.build
  body_text, get_status_code = get.("#{path}/0")

  test "Post responds with successful status" do
    assert(post_status_code == 201)
  end

  test "Get responds with successful status" do
    assert(get_status_code == 200)
  end

  test "Written data is retrieved" do
    control_data = JSON.parse(data)[0]['data']
    control_metadata = JSON.parse(data)[0]['metadata']

    body = JSON.parse(body_text)

    content = body['content']
    data = content['data']
    metadata = content['metadata']

    assert(data == control_data)
    assert(metadata == control_metadata)
  end
end
