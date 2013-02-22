require 'rake'
require 'rake/tasklib'
require 'rake/testtask'
require 'yaml'

module GS::Rake
  class TestTask < Rake::TaskLib
    attr_accessor :ruby, :ruby_special, :js

    def initialize(options = {})
      self.ruby = options[:ruby] || []
      self.ruby_special = options[:ruby_special] || []
      self.js = options[:js] || []

      yield self if block_given?
      define
    end

    def define
      namespace :test do
        (self.ruby + self.ruby_special).each do |dir|
          task_dir = "test/#{dir}"
          next if File.file?(File.join(Dir.pwd, task_dir))

          Rake::TestTask.new(task_dir.split('/').last) do |t|
            t.libs << "test"
            t.pattern = "#{task_dir}/**/*_test.rb"
            t.verbose = true
          end
        end

        desc 'Run all tests'
        task :all do
          dirs = (self.js + self.ruby).collect { |dir| "test/#{dir}" }
          errors = dirs.collect do |task_dir|
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

        desc 'Run tests for JavaScript'
        task :js do
          system('node test/js/run.js --noColor')
          abort unless $?.success?
        end

        Rake::TestTask.new('flat') do |t|
          t.libs << 'test'
          t.pattern = 'test/**/*_test.rb'
          t.verbose = true
        end
      end
    end
  end
end
