# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "restrack-client/version"

Gem::Specification.new do |s|
  s.name        = "restrack-client"
  s.version     = RESTRackClient::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Chris St. John']
  s.email       = ['chris@stjohnstudios.com']
  s.homepage    = 'http://github.com/stjohncj/RESTRack-Client'
  s.summary     = %q{A library for interacting with RESTful web services.  Use this to communicate with RESTRack based services.}
  s.description = %q{A library for interacting with RESTful web services.  Use this to communicate with RESTRack based services.}
  s.rubyforge_project = "restrack-client"
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_development_dependency 'shoulda'
  s.add_runtime_dependency 'mime-types'
  s.add_runtime_dependency 'i18n'
  s.add_runtime_dependency 'json'
  s.add_runtime_dependency 'xml-simple', '>= 1.0.13'
  
end
