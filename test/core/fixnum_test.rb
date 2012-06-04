require 'test_helper'

describe Fixnum do
  describe 'time helpers' do
    it 'should handle seconds' do
      1.second.must_equal 1
      15.seconds.must_equal 15
      100.seconds.must_equal 100
    end

    it 'should handle minutes' do
      1.minute.must_equal 60
      5.minutes.must_equal 300
      60.minutes.must_equal 3600
    end

    it 'should handle hours' do
      1.hour.must_equal 3600
      9.hours.must_equal 32400
      50.hours.must_equal 180000
    end

    it 'should handle days' do
      1.day.must_equal 24 * 3600
      7.days.must_equal 7 * 24 * 3600
      25.days.must_equal 25 * 24 * 3600
    end
  end
end