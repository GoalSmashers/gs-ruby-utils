require 'rake'
require 'rake/tasklib'
require 'rake/testtask'
require 'yaml'

module GS::Rake
  class SpecTask < Rake::TaskLib
    attr_accessor :ruby, :ruby_special, :js

    def initialize(options = {})
      self.ruby = options[:ruby] || []
      self.ruby_special = options[:ruby_special] || []
      self.js = options[:js] || []

      yield self if block_given?
      define
    end

    def define
      namespace :spec do
        (self.ruby + self.ruby_special).each do |dir|
          task_dir = "spec/#{dir}"
          next if File.file?(File.join(Dir.pwd, task_dir))

          Rake::TestTask.new(task_dir.split('/').last) do |t|
            t.libs << "spec"
            t.pattern = "#{task_dir}/**/*_spec.rb"
            t.verbose = true
          end
        end

        desc 'Run all specs'
        task :all do
          dirs = (self.js + self.ruby).collect { |dir| "spec/#{dir}" }
          errors = dirs.collect do |task_dir|
            next if File.file?(File.join(Dir.pwd, task_dir))

            task = task_dir.split('/').last
            begin
              Rake::Task["spec:#{task}"].invoke
              nil
            rescue => e
              task
            end
          end.compact
          abort "Errors running #{errors.join(', ')}!" if errors.any?
        end

        desc 'Run specs for JavaScript'
        task :js do
          system('node spec/js/run.js --noColor')
          abort unless $?.success?
        end

        Rake::TestTask.new('flat') do |t|
          t.libs << 'spec'
          t.pattern = 'spec/**/*_spec.rb'
          t.verbose = true
        end
      end
    end
  end
end
