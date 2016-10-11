# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = 'event_store-client-http'
  s.version = '0.7.1.2'
  s.summary = 'HTTP Client for EventStore'
  s.description = ' '

  s.authors = ['The Eventide Project']
  s.email = 'opensource@eventide-project.org'
  s.homepage = 'https://github.com/eventide-project/event-store-client-http'
  s.licenses = ['MIT']

  s.require_paths = ['lib']
  s.files = Dir.glob('{lib}/**/*')
  s.platform = Gem::Platform::RUBY

  s.add_runtime_dependency 'clock'
  s.add_runtime_dependency 'casing'
  s.add_runtime_dependency 'configure'
  s.add_runtime_dependency 'connection-client'
  s.add_runtime_dependency 'event_store-client'
  s.add_runtime_dependency 'http-commands'
  s.add_runtime_dependency 'schema'
  s.add_runtime_dependency 'serialize'
  s.add_runtime_dependency 'settings'

  s.add_development_dependency 'test_bench'
end
