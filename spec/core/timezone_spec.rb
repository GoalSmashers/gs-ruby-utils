require 'spec_helper'

describe TZInfo::Timezone do
  describe 'local' do
    it 'should return proper time via local' do
      utc = TZInfo::Timezone.get('UTC')
      utc.local(2013,1,1).must_equal Time.utc(2013,1,1)
    end
  end

  describe 'at' do
    it 'should return proper time from integer stamp' do
      TZInfo::Timezone.get('UTC').at(1316649600).must_equal Time.utc(2011,9,22,2)
    end

    it 'should return proper time from float stamp' do
      TZInfo::Timezone.get('UTC').at(1316649600.0).must_equal Time.utc(2011,9,22,2)
    end

    it 'should return proper time from float stamp' do
      TZInfo::Timezone.get('Europe/Moscow').at(1316649600.0).must_equal Time.utc(2011,9,22,6)
    end
  end
end
