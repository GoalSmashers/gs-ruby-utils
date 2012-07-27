require 'rake'
require 'rake/tasklib'

module GS::Rake
  class AssetsTask < Rake::TaskLib
    def initialize
      yield self if block_given?
      define
    end

    def define
      namespace :assets do
        desc 'Package assets for deployment'
        task :pkg do
          only = ENV['ONLY']
          cache_booster = ['staging', 'production'].include?(ENV['RACK_ENV']) ? '-b ' : ''

          if only
            system("assetspkg -g #{cache_booster} -o #{only}")
          else
            system("assetspkg -g #{cache_booster}");
          end
        end

        desc 'Clean up packaged assets'
        task :clean do
          system('rm -rvf config/.assets.yml.json')
          system('rm -rvf public/javascripts/bundled')
          system('rm -rvf public/stylesheets/bundled')
          system('find public/stylesheets -name *.css -print0 | xargs -0 rm -rf')
        end
      end
    end
  end
end