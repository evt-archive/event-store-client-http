require_relative '../bench_init'

context "Posting event data fails, wrong event number error" do
  session = EventStore::Client::HTTP::Session.build
  post = EventSource::EventStore::HTTP::Request::Post.build session: session

  session_substitute = SubstAttr::Substitute.(:session, post)

  path = 'some-path'
  data = 'some-data'

  session_substitute.set_response 400, reason_phrase: 'Wrong expected EventNumber'

  test "Raises an ExpectedVersionError" do
    assert proc { post.(path, path) } do
      raises_error? EventStore::Client::HTTP::Request::Post::ExpectedVersionError
    end
  end
end
