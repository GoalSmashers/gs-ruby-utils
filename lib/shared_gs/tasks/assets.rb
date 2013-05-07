require 'rake'
require 'rake/tasklib'

module GS::Rake
  class AssetsTask < Rake::TaskLib
    attr_accessor :pkg_callback

    def initialize
      yield self if block_given?
      define
    end

    def define
      namespace :assets do
        desc 'Package assets for deployment'
        task :pkg, :only do |t, args|
          path = "./node_modules/assets-packager/bin"
          cache_booster = ['staging', 'production'].include?(ENV['RACK_ENV']) ? '-b ' : ''

          if args[:only]
            system("#{path}/assetspkg -l 80 -g #{cache_booster} -o #{args[:only]}")
          else
            system("#{path}/assetspkg -l 80 -g #{cache_booster}");
          end

          pkg_callback.yield if pkg_callback
        end

        desc 'Clean up packaged assets'
        task :clean do
          system('rm -rvf config/.assets.yml.json')
          system('rm -rvf public/javascripts/bundled')
          system('rm -rvf public/stylesheets/bundled')
          system('find public/stylesheets -name *.css -print0 | xargs -0 rm -rf')
        end

        desc "Run JSHint tests"
        task :js_check do
          puts "Valid!" if system("./node_modules/jshint/bin/hint .")
        end
      end
    end
  end
end
