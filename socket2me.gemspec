# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'socket2me/version'

Gem::Specification.new do |spec|
  spec.name          = 'socket2me'
  spec.version       = Socket2me::VERSION
  spec.authors       = ['Scott Pierce']
  spec.email         = ['ddrscott@gmail.com']

  spec.summary       = 'Execute Javascript in the browser from the server using WebSockets'
  spec.homepage      = 'https://github.com/ddrscott/socket2me'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|examples)/}) }
  spec.require_paths = ['lib']

  spec.add_dependency 'rack', '>= 1.6'
  spec.add_dependency 'em-websocket', '~> 0.5'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.4'
  spec.add_development_dependency 'pry'
end
