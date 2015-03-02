# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'gs_ruby_utils/version'

Gem::Specification.new do |s|
  s.name = 'gs_ruby_utils'
  s.version = GS::VERSION
  s.authors = ['Jakub Pawlowicz']
  s.email = ['jakub.pawlowicz@goalsmashers.com']
  s.homepage = ''
  s.summary = %q{Shared GoalSmashers utility code}
  s.description = %q{We use them as a shared library in our projects for things like messaging, jobs, email previews, etc}

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = %w(lib)
end
