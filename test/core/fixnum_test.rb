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

    it 'should handle weeks' do
      1.week.must_equal 7 * 24 * 3600
      7.weeks.must_equal 7 * 7 * 24 * 3600
      25.weeks.must_equal 25 * 7 * 24 * 3600
    end

    it 'should handle months' do
      1.month.must_equal 30 * 24 * 3600
      5.months.must_equal 5 * 30 * 24 * 3600
    end

    it 'should handle years' do
      1.year.must_equal 365.25 * 24 * 3600
      3.years.must_equal 3 * 365.25 * 24 * 3600
    end
  end

  describe 'time diffs' do
    it 'should calculate ago' do
      Timecop.freeze(Time.now) do
        1.minute.ago.must_equal (Time.now - 1.minute)
        2.hours.ago.must_equal (Time.now - 2.hours)
        5.days.ago.must_equal (Time.now - 5.days)
      end
    end

    it 'should calculate since' do
      Timecop.freeze(Time.now) do
        10.seconds.since.must_equal (Time.now + 10.seconds)
        5.minutes.since.must_equal (Time.now + 5.minutes)
        2.hours.since.must_equal (Time.now + 2.hours)
        1.day.since.must_equal (Time.now + 1.day)
        2.months.since.must_equal (Time.now + 2.months)
        4.years.since.must_equal (Time.now + 4.years)
      end
    end
  end
end