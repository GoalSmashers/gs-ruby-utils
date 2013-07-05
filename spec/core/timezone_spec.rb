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
      zone('UTC').at(1316649600).hour.must_equal 0
    end

    it 'should return proper time from float stamp' do
      zone('UTC').at(1316649600.0).hour.must_equal 0
    end

    it 'should return proper time from float stamp' do
      zone('Europe/Moscow').at(1316649600.0).hour.must_equal 4
    end
  end

  private

  def zone(name)
    TZInfo::Timezone.get(name)
  end
end
