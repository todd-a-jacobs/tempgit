# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'tempgit/version'

Gem::Specification.new do |s|
  s.name        = 'tempgit'
  s.version     = TempGit::VERSION
  s.authors     = ['Todd A. Jacobs']
  s.email       = ['spamivore+tempgit@codegnome.org']
  s.homepage    = "https://github.com/CodeGnome/#{s.name}"
  s.summary     = %q{Integrate Git with TDD.}
  s.description = %q{Mechanize temporary Git repositories during testing.}
  s.files         = `git ls-files [A-z]*`.split("\n")
  s.test_files    = `git ls-files -- spec/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']
  s.required_ruby_version = '>= 1.9.2'

  # specify any dependencies here; for example:
  s.add_development_dependency 'rspec'
end
