require_relative 'rack_test_helper'

module GS::Tests
  module ControllerTestHelper
    include RackTestHelper

    def teardown
      super

      header 'User-Agent', ''
    end

    def app_for(context)
      Rack::Builder.app do
        run Rack::Cascade.new [context].compact
      end
    end

    def session(user, &block)
      # TBI
    end
  end
end
