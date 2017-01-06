require_relative '../bench_init'

context "Posting event data fails, failure is unknown" do
  session = EventStore::Client::HTTP::Session.build
  post = EventSource::EventStore::HTTP::Request::Post.build session: session

  session_substitute = SubstAttr::Substitute.(:session, post)

  path = 'some-path'
  data = 'some-data'

  session_substitute.set_response 500

  test "Is an error" do
    assert proc { post.(path, data) } do
      raises_error? EventStore::Client::HTTP::Request::Post::Error
    end
  end
end
