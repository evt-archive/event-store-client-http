require_relative '../bench_init'

context "Posting event data fails, write timeout" do
  post = EventStore::Client::HTTP::Request::Post.build

  session_substitute = SubstAttr::Substitute.(:session, post)

  path = 'some-path'
  data = 'some-data'

  session_substitute.set_response 500, reason_phrase: 'Write timeout'

  test "Raises a WriteTimeoutError" do
    assert proc { post.(path, data) } do
      raises_error? EventStore::Client::HTTP::Request::Post::WriteTimeoutError
    end
  end
end
