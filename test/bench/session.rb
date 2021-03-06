require_relative 'bench_init'

context 'Session' do
  test 'Varying the settings used for construction' do
    settings = Settings.build(
      :some_namespace => {
        :host => 'www.example.com',
        :port => 80
      }
    )

    session = EventStore::Client::HTTP::Session.build settings, namespace: 'some_namespace'

    assert session.host == 'www.example.com'
    assert session.port == 80
  end

  test 'Substitute' do
    substitute = SubstAttr::Substitute.build EventStore::Client::HTTP::Session

    assert substitute.instance_of?(EventSource::EventStore::HTTP::Session::Substitute::Session)
  end
end
