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
end
