require 'rubygems'
require 'bundler/setup'
Bundler.setup
Bundler.require

gem 'minitest'
require 'minitest/autorun'
require 'flexmock'
require 'sham'
require 'faker'
require_relative '../lib/shared_gs'

# Test helpers
Sham.email { Faker::Internet.email }

module Mail
  def self.bulk_deliver(messages)
    # Swallow
  end
end
