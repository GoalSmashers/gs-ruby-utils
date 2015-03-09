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
          desc 'Create database'
          task :create do
            system(%{psql -U #{config['user']} -h #{config['host']} -c "CREATE DATABASE #{config['database']} OWNER #{config['user']} ENCODING 'UTF-8' TEMPLATE template0"})
          end

          desc 'Drop database'
          task :drop do
            system(%{psql -U #{config['user']} -h #{config['host']} -c "DROP DATABASE #{config['database']}"})
          end

          desc 'Run database migrations'
          task :migrate do
            system("sequel -m db/migrations -e #{env} -E config/database.yml")
          end

          desc 'Rollback last database migration'
          task :rollback do
            target_version = open("|psql #{config['database']} -U #{config['user']} -h #{config['host']} -c 'select version from schema_info' -t -A").gets.to_i - 1
            fail "Can't find schema info" if target_version < 0

            system("sequel -m db/migrations -M #{target_version} -e #{env} -E config/database.yml")
          end
        end
      end

      private

      def env
        ENV.fetch('RACK_ENV', 'development')
      end

      def config
        @_config ||= YAML.load_file('config/database.yml').fetch(env)
      end
    end
  end
end
