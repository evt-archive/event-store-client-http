require_relative 'bench_init'

context "Posting event data fails" do
  post = EventStore::Client::HTTP::Request::Post.new

  session_substitute = post.session

  path = 'some-path'
  data = 'some-data'

  context "Status code is not 201" do
    session_substitute.set_response 1

    test "Is an error" do
      assert proc { post.(data, path) } do
        raises_error? EventStore::Client::HTTP::Request::Post::Error
      end
    end
  end
end
