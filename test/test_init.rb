ENV['CONSOLE_DEVICE'] ||= 'stdout'
ENV['LOG_COLOR'] ||= 'on'

if ENV['LOG_LEVEL']
  ENV['LOGGER'] ||= 'on'
else
  ENV['LOG_LEVEL'] ||= 'trace'
end

ENV['LOGGER'] ||= 'off'
ENV['LOG_OPTIONAL'] ||= 'on'

ENV['DISABLE_EVENT_STORE_LEADER_DETECTION'] ||= 'on'

puts RUBY_DESCRIPTION

require_relative '../init.rb'

require 'event_store/client/http/controls'

require 'test_bench/activate'

Telemetry::Logger::AdHoc.activate
