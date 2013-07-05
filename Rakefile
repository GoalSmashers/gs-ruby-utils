require "bundler/gem_tasks"
require 'rake/testtask'

desc 'Run all specs'
Rake::TestTask.new('spec') do |t|
  t.libs << "spec"
  t.pattern = "spec/**/*_spec.rb"
  t.verbose = true
end
