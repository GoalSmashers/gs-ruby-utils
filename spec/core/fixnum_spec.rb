require 'spec_helper'

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
      1.month.value.must_equal 30 * 24 * 3600
      5.months.value.must_equal 5 * 30 * 24 * 3600
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
        4.years.since.must_equal (Time.now + 4.years)
      end
    end

    it 'should calculate ago for month' do
      Timecop.freeze(2013, 7, 1) do
        1.month.ago.must_equal (Time.zone.now - 1.month)
      end
    end

    it 'should calculate since fro month' do
      Timecop.freeze(2013, 7, 1) do
        2.months.since.must_equal (Time.zone.now + 2.months)
      end
    end
  end

  describe 'ago from date' do
    it 'should calculate ago from date' do
      (Time.zone.local(2014,1,1) - 1.month).must_equal Time.zone.local(2013,12,1)
    end
  end

  describe 'since from date' do
    it 'should calculate since from date' do
      (Time.zone.local(2014,1,1) + 12.month).must_equal Time.zone.local(2015,1,1)
    end
  end

  describe 'ago in months' do
    describe 'no trimming' do
      it 'should be ok for 31st' do
        Timecop.freeze(Time.zone.local(2013,1,31)) do
          1.month.ago.must_equal Time.zone.local(2012,12,31)
        end
      end

      it 'should be ok for 30th' do
        Timecop.freeze(Time.zone.local(2013,1,30)) do
          3.months.ago.must_equal Time.zone.local(2012,10,30)
        end
      end

      it 'should be ok for 29th' do
        Timecop.freeze(Time.zone.local(2012,2,29)) do
          5.months.ago.must_equal Time.zone.local(2011,9,29)
        end
      end

      it 'should be ok for 28th' do
        Timecop.freeze(Time.zone.local(2012,2,28)) do
          15.months.ago.must_equal Time.zone.local(2010,11,28)
        end
      end

      it 'should be ok for 1st' do
        Timecop.freeze(Time.zone.local(2012,2,1)) do
          1.month.ago.must_equal Time.zone.local(2012,1,1)
        end
      end

      it 'should be ok when moving 7 months back' do
        Timecop.freeze(Time.zone.local(2013,5,30)) do
          1.month.ago.must_equal Time.zone.local(2013,4,30)
          2.months.ago.must_equal Time.zone.local(2013,3,30)
          3.months.ago.must_equal Time.zone.local(2013,2,28)
          4.months.ago.must_equal Time.zone.local(2013,1,30)
          5.months.ago.must_equal Time.zone.local(2012,12,30)
          6.months.ago.must_equal Time.zone.local(2012,11,30)
          7.months.ago.must_equal Time.zone.local(2012,10,30)
        end
      end

      it 'should be ok when moving 7 months forward' do
        Timecop.freeze(Time.zone.local(2013,5,31)) do
          1.month.since.must_equal Time.zone.local(2013,6,30)
          2.months.since.must_equal Time.zone.local(2013,7,31)
          3.months.since.must_equal Time.zone.local(2013,8,31)
          4.months.since.must_equal Time.zone.local(2013,9,30)
          5.months.since.must_equal Time.zone.local(2013,10,31)
          6.months.since.must_equal Time.zone.local(2013,11,30)
          7.months.since.must_equal Time.zone.local(2013,12,31)
        end
      end
    end

    describe 'trimming' do
      it 'should trim from 31st to 30th' do
        Timecop.freeze(Time.zone.local(2013,5,31)) do
          1.month.ago.must_equal Time.zone.local(2013,4,30)
        end
      end

      it 'should trim from 31st to 29th' do
        Timecop.freeze(Time.zone.local(2012,5,31)) do
          3.months.ago.must_equal Time.zone.local(2012,2,29)
        end
      end

      it 'should trim from 31st to 28th' do
        Timecop.freeze(Time.zone.local(2013,5,31)) do
          3.months.ago.must_equal Time.zone.local(2013,2,28)
        end
      end

      it 'should trim from 29th to 28th' do
        Timecop.freeze(Time.zone.local(2012,2,29)) do
          12.months.ago.must_equal Time.zone.local(2011,2,28)
        end
      end

      it 'should trim from 31st to 28th in non leap year' do
        Timecop.freeze(Time.zone.local(2003,3,31)) do
          37.months.ago.must_equal Time.zone.local(2000,2,28)
        end
      end
    end
  end

  describe 'since in months' do
    describe 'no trimming' do
      it 'should be ok for 31st' do
        Timecop.freeze(Time.zone.local(2013,5,31)) do
          3.months.since.must_equal Time.zone.local(2013,8,31)
        end
      end

      it 'should be ok for 30th' do
        Timecop.freeze(Time.zone.local(2013,4,30)) do
          2.months.since.must_equal Time.zone.local(2013,6,30)
        end
      end

      it 'should be ok for 29th' do
        Timecop.freeze(Time.zone.local(2012,2,29)) do
          5.months.since.must_equal Time.zone.local(2012,7,29)
        end
      end

      it 'should be ok for 28th' do
        Timecop.freeze(Time.zone.local(2012,2,28)) do
          15.months.since.must_equal Time.zone.local(2013,5,28)
        end
      end

      it 'should be ok for 1st' do
        Timecop.freeze(Time.zone.local(2012,2,1)) do
          18.months.ago.must_equal Time.zone.local(2010,8,1)
        end
      end
    end

    describe 'trimming' do
      it 'should trim from 31st to 30th' do
        Timecop.freeze(Time.zone.local(2013,5,31)) do
          1.month.since.must_equal Time.zone.local(2013,6,30)
        end
      end

      it 'should trim from 31st to 29th' do
        Timecop.freeze(Time.zone.local(2011,12,31)) do
          2.months.since.must_equal Time.zone.local(2012,2,29)
        end
      end

      it 'should trim from 31st to 28th' do
        Timecop.freeze(Time.zone.local(2012,12,31)) do
          2.months.since.must_equal Time.zone.local(2013,2,28)
        end
      end

      it 'should trim from 29th to 28th' do
        Timecop.freeze(Time.zone.local(2012,2,29)) do
          12.months.since.must_equal Time.zone.local(2013,2,28)
        end
      end
    end
  end
end
