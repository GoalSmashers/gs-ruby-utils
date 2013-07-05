require 'rake'
require 'rake/tasklib'
require 'yaml'

module GS
  module Rake
    class BackgroundTask < ::Rake::TaskLib
      def initialize(root_path, options = {})
        @root_path = root_path
        @job_limit = options[:job_limit] || 100
        @sleep_time = options[:sleep_time] || 5
        @max_attempts = options[:max_attempts] || 5

        yield self if block_given?
        define
      end

      def define
        namespace :background do
          desc "Run navvy work"
          task :run do
            require File.join(@root_path, 'config', 'boot.rb')

            Navvy.configure do |config|
              config.job_limit = @job_limit
              config.keep_jobs = false
              config.logger = Navvy::Logger.new(File.join(@root_path, 'log', 'background.log'))
              config.sleep_time = @sleep_time
              config.max_attempts = @max_attempts
            end
            Navvy::Worker.start
          end
        end
      end
    end
  end
end
