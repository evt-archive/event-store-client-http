require_relative '../bench_init'

context "Posting event data fails, failure is unknown" do
  post = EventStore::Client::HTTP::Request::Post.new

  session_substitute = post.session

  path = 'some-path'
  data = 'some-data'

  session_substitute.set_response 500

  test "Is an error" do
    assert proc { post.(data, path) } do
      raises_error? EventStore::Client::HTTP::Request::Post::Error
    end
  end
end
