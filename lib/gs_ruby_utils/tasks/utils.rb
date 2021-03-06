require 'rake'
require 'rake/tasklib'

module GS
  module Rake
    class UtilsTask < ::Rake::TaskLib
      def initialize
        yield self if block_given?
        define
      end

      def define
        desc "Open psql session"
        task :db, :env do |t, args|
          require 'yaml'

          env = args[:env] || 'development'
          db_config = YAML.load_file(File.join('config', 'database.yml'))[env]

          system("psql -U #{db_config['user']} #{db_config['database']}")
        end

        desc "Open pry session"
        task :c, :env do |t, args|
          ENV['RACK_ENV'] = args[:env] || 'development'
          exec('bundle exec pry -r ./config/boot')
        end
      end
    end
  end
end
