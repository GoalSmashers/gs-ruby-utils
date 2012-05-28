require 'rake'
require 'rake/tasklib'
require 'rake/testtask'
require 'yaml'

module GS::Rake
  class TestTask < Rake::TaskLib
    def initialize
      yield self if block_given?
      define
    end

    def define
      namespace :test do
        Dir['test/*'].each do |task_dir|
          next if File.file?(File.join(Dir.pwd, task_dir))

          Rake::TestTask.new(task_dir.split('/').last) do |t|
            t.libs << "test"
            t.pattern = "#{task_dir}/**/*_test.rb"
            t.verbose = true
          end
        end

        desc 'Run all tests'
        task :all do
          errors = Dir['test/*'].collect do |task_dir|
            next if File.file?(File.join(Dir.pwd, task_dir))

            begin
              Rake::Task["test:#{task_dir.split('/').last}"].invoke
              nil
            rescue => e
              task
            end
          end.compact
          abort "Errors running #{errors.join(', ')}!" if errors.any?
        end
      end
    end
  end
end
