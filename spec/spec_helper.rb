ENV['RACK_ENV'] = 'test'
require 'rubygems'
require 'bundler/setup'
Bundler.setup
Bundler.require(:default, :test)

gem 'minitest'
require 'minitest/autorun'
require 'flexmock'
require 'fabrication'
require 'rack/test'

require 'gs_ruby_utils/specs/controller_spec_helper'
require 'gs_ruby_utils/specs/mail_spec_helper'

require 'gs_ruby_utils/controllers/application'

# Fake host
ENV['GS_HOST'] = 'fake.host'

# Dummy application
class Application < Sinatra::Base
  include GS::Controllers::Application
end

# Test helpers
Fabricate.sequence(:email) { |i| "user#{i}@example.com" }
