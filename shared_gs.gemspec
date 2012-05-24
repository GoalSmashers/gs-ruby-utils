# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "shared_gs/version"

Gem::Specification.new do |s|
  s.name        = "shared_gs"
  s.version     = GS::VERSION
  s.authors     = ["Jakub Pawlowicz"]
  s.email       = ["jakub@goalsmashers.com"]
  s.homepage    = ""
  s.summary     = %q{TODO: Shared GS artifacts}
  s.description = %q{TODO: Shared GS artifacts}

  # s.rubyforge_project = "shared_gs"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
