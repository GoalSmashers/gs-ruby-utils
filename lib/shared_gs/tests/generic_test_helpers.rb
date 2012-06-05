module GS::Tests
  module GenericTestHelpers
    def assert_email_sent(count = 1, &block)
      Mail::TestMailer.deliveries.clear

      block.yield

      assert_equal(count, Mail::TestMailer.deliveries.length)
    end

    def assert_difference(condition, difference = 1, &block)
      before = eval(condition)
      block.yield
      assert_equal(before + difference, eval(condition))
    end

    def assert_no_difference(condition, &block)
      assert_difference(condition, 0) do
        block.yield
      end
    end
  end
end
