ENV['LOGGER'] ||= 'on'
ENV['LOG_LEVEL'] ||= 'info'

require_relative './scripts_init'

$stream_name = EventStore::Client::HTTP::Controls::Writer.write 25

require 'benchmark/ips'
require 'net/http'

def stream_name
  $stream_name
end

def net_http
  $net_http ||= Net::HTTP.start 'localhost', '2113'
end

def net_http_embed_body
  path = "/streams/#{stream_name}/0/forward/25"

  uri = URI::HTTP.build(
    host: "localhost",
    path: path,
    query: URI.encode_www_form(:embed => 'body'),
    port: 2113
  )

  request = Net::HTTP::Get.new uri
  request['Accept'] = 'application/vnd.eventstore.atom+json'

  http_response = net_http.request request

  fail http_response.code.to_s unless http_response.code == '200'

  JSON.parse http_response.body
end

def eventide_client
  reader = EventStore::Client::HTTP::Reader.build stream_name

  reader.each do |event|
  end
end

Benchmark.ips do |bm|
  bm.report "eventide" do
    eventide_client
  end

  bm.report "net/http" do
    net_http_embed_body
  end

  bm.compare!
end
