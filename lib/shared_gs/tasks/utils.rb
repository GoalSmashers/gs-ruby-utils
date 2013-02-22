require 'rake'
require 'rake/tasklib'

module GS::Rake
  class UtilsTask < Rake::TaskLib
    def initialize
      yield self if block_given?
      define
    end

    def define
      desc "Open psql session"
      task :db do
        require 'yaml'

        env = ARGV[1] || 'development'
        db_config = YAML.load_file(File.join('config', 'database.yml'))[env]

        system("psql -U #{db_config['user']} #{db_config['database']}")
      end

      desc "Open racksh session"
      task :c do
        ENV['RACK_ENV'] = ARGV[1] || 'development'
        system("bundle exec racksh")
      end
    end
  end
end