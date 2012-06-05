require_relative 'rack_test_helpers'
require_relative 'generic_test_helpers'

module GS::Tests
  module ControllerTestHelpers
    include GenericTestHelpers
    include RackTestHelpers

    def setup
      super
    end

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