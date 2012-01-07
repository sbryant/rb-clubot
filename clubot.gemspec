# -*- encoding: utf-8 -*-

lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'clubot/version'

Gem::Specification.new do |s|
  s.name          = "clubot"
  s.version       = Clubot::VERSION
  s.platform      = Gem::Platform::RUBY
  s.authors       = ["Sean Bryant"]
  s.email         = ["sean@hackinggibsons.com"]
  s.homepage      = "https://github.com/sbryant/rb-clubot"
  s.summary       = "A client interface to clubot."
  s.description   = "This is a bare-bones client for clubot intended to help other people write bot backends for clubot."

  s.add_dependency "zmq", ["~> 2.1.0"]
  s.add_dependency "json", [">= 1.6.0"]

  git_files       = `git ls-files`.split("\n") rescue ''
  s.files         = git_files
  s.require_paths = ['lib']
end
