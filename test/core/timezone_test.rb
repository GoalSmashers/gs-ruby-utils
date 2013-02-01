require 'test_helper'

describe TZInfo::Timezone do
  describe 'local' do
    it 'should return proper time via local' do
      utc = TZInfo::Timezone.get('UTC')
      utc.local(2013,1,1).must_equal Time.utc(2013,1,1)
    end
  end
end