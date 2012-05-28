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
      # TBI
    end

    def session(user, &block)
      # TBI
    end
  end
end