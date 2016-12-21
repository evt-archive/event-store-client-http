# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = 'event_store-client-http'
  s.version = '0.10.2.0'
  s.summary = 'HTTP Client for EventStore'
  s.description = ' '

  s.authors = ['The Eventide Project']
  s.email = 'opensource@eventide-project.org'
  s.homepage = 'https://github.com/eventide-project/event-store-client-http'
  s.licenses = ['MIT']

  s.require_paths = ['lib']
  s.files = Dir.glob('{lib}/**/*')
  s.platform = Gem::Platform::RUBY

  s.add_runtime_dependency 'event_source-event_store-http'

  s.add_development_dependency 'test_bench'
end
