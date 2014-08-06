# -*- encoding: utf-8 -*-
require "./lib/lunchy"

Gem::Specification.new do |s|
  s.name        = "lunchy"
  s.version     = Lunchy::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Mike Perham"]
  s.email       = ["mperham@gmail.com"]
  s.homepage    = "http://github.com/mperham/lunchy"
  s.summary     = s.description = %q{Friendly wrapper around launchctl}
  s.licenses    = ['MIT']

  s.add_development_dependency "rake"
  s.add_development_dependency 's3'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
