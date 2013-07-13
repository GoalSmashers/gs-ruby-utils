require 'rake'
require 'rake/tasklib'
require 'rake/testtask'
require 'yaml'

module GS
  module Rake
    class SpecTask < ::Rake::TaskLib
      def initialize(options = {})
        @extra = options.fetch(:extra, [])
        @js = options.fetch(:js, [])

        yield self if block_given?
        define
      end

      def define
        desc 'Run all specs'
        task :spec do
          errors = (js + ['rb']).collect do |task|
            begin
              ::Rake::Task["spec:#{task}"].invoke
              nil
            rescue => e
              task
            end
          end.compact
          abort "Errors running #{errors.join(', ')}!" if errors.any?
        end

        namespace :spec do
          ::Rake::TestTask.new('group') do |t|
            t.libs << 'spec'
            t.pattern = "#{ENV['IN']}/**/*_spec.rb"
            t.verbose = true
          end

          ::Rake::TestTask.new('rb') do |t|
            t.libs << 'spec'
            t.test_files = Dir['spec/**/*_spec.rb'].delete_if { |p| p =~ extra_pattern }
            t.verbose = false
          end

          desc 'Run specs for JavaScript'
          task :js do
            system('node spec/js/run.js --noColor')
            abort unless $?.success?
          end
        end
      end

      private

      attr_accessor :extra, :js

      def extra_pattern
        @_extra_pattern ||= begin
          all_extras = @extra + ['setup']
          %r(^spec/(#{all_extras.join('|')})/)
        end
      end
    end
  end
end
