module GS::Tests
  module JobTestHelpers
    def job
      self.class.to_s.constantize
    end

    def test_should_descend_from_abstract_job
      (job < AbstractJob).must_equal true
    end
  end
end