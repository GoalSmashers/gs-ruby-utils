require 'rake'
require 'rake/tasklib'
require 'yaml'

module GS
  module Rake
    class SequelTask < ::Rake::TaskLib
      def initialize
        yield self if block_given?
        define
      end

      def define
        namespace :db do
          desc 'Run database migrations'
          task :migrate do
            system("sequel -m db/migrations -e #{ENV['RACK_ENV'] || 'development'} -E config/database.yml")
          end

          desc 'Rollback last database migration'
          task :rollback do
            config = YAML.load_file('config/database.yml')
            env = ENV['RACK_ENV'] || 'development'
            database = config[env]['database']
            target_version = open("|psql #{database} -U goalsmashers -c 'select version from schema_info' -t -A").gets.to_i - 1

            system("sequel -m db/migrations -M #{target_version} -e #{env} -E config/database.yml")
          end
        end
      end
    end
  end
end
