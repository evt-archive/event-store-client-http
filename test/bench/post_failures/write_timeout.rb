require_relative '../bench_init'

context "Posting event data fails, write timeout" do
  post = EventStore::Client::HTTP::Request::Post.new

  session_substitute = post.session

  path = 'some-path'
  data = 'some-data'

  session_substitute.set_response 500, reason_phrase: 'Write timeout'

  test "Raises a WriteTimeoutError" do
    assert proc { post.(data, path) } do
      raises_error? EventStore::Client::HTTP::Request::Post::WriteTimeoutError
    end
  end
end
