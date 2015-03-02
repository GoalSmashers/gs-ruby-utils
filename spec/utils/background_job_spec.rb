require 'spec_helper'
require 'gs_ruby_utils/jobs/abstract_job'
require 'gs_ruby_utils/utils/background_job'

include GS::Utils
include GS::Jobs

class TestJob < AbstractJob
end

describe BackgroundJob do
  include FlexMock::TestCase

  it "should call job's perform method" do
    options = { a: 1, b: 2 }
    flexmock(TestJob)
      .should_receive(:perform)
      .once
      .with(options)
      .and_return(true)

    BackgroundJob.schedule(:test, options)
  end
end
