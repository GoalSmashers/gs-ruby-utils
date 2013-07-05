module GS::Specs
  module JobSpecHelper
    def job
      self.class.to_s.constantize
    end

    def test_should_descend_from_abstract_job
      (job < GS::Jobs::AbstractJob).must_equal true
    end
  end
end
