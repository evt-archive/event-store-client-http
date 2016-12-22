require_relative '../bench_init'

context "Posting event data fails, wrong event number error" do
  post = EventStore::Client::HTTP::Request::Post.new

  session_substitute = post.session

  path = 'some-path'
  data = 'some-data'

  session_substitute.set_response 400, reason_phrase: 'Wrong expected EventNumber'

  test "Raises an ExpectedVersionError" do
    assert proc { post.(data, path) } do
      raises_error? EventStore::Client::HTTP::Request::Post::ExpectedVersionError
    end
  end
end
