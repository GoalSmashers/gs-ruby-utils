require_relative 'rack_spec_helper'

module GS
  module Specs
    module ControllerSpecHelper
      include RackSpecHelper

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
end
