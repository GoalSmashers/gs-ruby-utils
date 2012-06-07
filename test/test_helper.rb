require 'rubygems'
require 'bundler/setup'
Bundler.setup
Bundler.require(:default, :test)

gem 'minitest'
require 'minitest/autorun'
require 'flexmock'
require 'sham'
require 'faker'
require 'rack/test'

require 'shared_gs/tests/controller_test_helpers'

# Dummy application
class Application < Sinatra::Base
  include GS::Controllers::Application
  class << self
    include GS::Controllers::ApplicationClass
  end
end

# Test helpers
Sham.email { Faker::Internet.email }

module Mail
  def self.bulk_deliver(messages)
    # Swallow
  end
end

