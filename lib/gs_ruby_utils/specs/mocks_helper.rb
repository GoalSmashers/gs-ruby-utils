module GS
  module Specs
    module MocksHelper
      include FlexMock::Minitest

      def unmock(scope)
        if scope == :all
          flexmock_teardown
        else
          scope.try(:flexmock_teardown)
        end
      end

      def mock(*args, &block)
        flexmock(*args) do |mock|
          yield(mock) if block_given?
        end
      end

      alias_method :double, :mock

      def remock(object)
        unmock(object)
        mock(object)
      end
    end
  end
end
