require 'test_helper'

describe Time do
  it 'should process to_json' do
    now = Time.now
    zone = now.strftime('%z')

    now.to_json.must_equal "\"#{now.strftime('%FT%R:%S')}#{zone[0..2]}:#{zone[3..-1]}\""
  end

  it 'should correctly serialize and deserialize time' do
    now = Time.now
    json = JSON[[now]]
    JSON.parse(json)[0].must_equal now.iso8601.to_s
  end

  it 'should give midnight' do
    now = Time.now
    now.midnight.must_equal Time.zone.local(now.year, now.month, now.day)
  end

  it 'should give noon' do
    now = Time.now
    now.noon.must_equal Time.zone.local(now.year, now.month, now.day, 12)
  end

  it 'should give beginning of week' do
    7.times do |i|
      start_of_week = Time.utc(2013,1,21)
      Timecop.freeze(Time.utc(2013,1,21 + i)) do
        Time.zone.now.beginning_of_week.must_equal start_of_week
      end
    end
  end

  it 'should give end of week' do
    7.times do |i|
      end_of_week = Time.utc(2013,1,28) - 1.second
      Timecop.freeze(Time.utc(2013,1,21 + i)) do
        Time.zone.now.end_of_week.must_equal end_of_week
      end
    end
  end

  it 'should give next week' do
    7.times do |i|
      next_week = Time.utc(2013,1,28)
      Timecop.freeze(Time.utc(2013,1,21 + i)) do
        Time.zone.now.next_week.must_equal next_week
      end
    end
  end

  it 'should give beginning of a month' do
    now = Time.now
    now.beginning_of_month.must_equal Time.zone.local(now.year, now.month)
  end

  it 'should give end of a month' do
    now = Time.utc(2013, 1)
    now.end_of_month.must_equal Time.zone.local(now.year, now.month + 1) - 1.second
  end

  it 'should give end of a month for December' do
    now = Time.utc(2013, 12)
    now.end_of_month.must_equal Time.zone.local(now.year + 1, 1) - 1.second
  end

  it 'should give beginning of a year' do
    now = Time.now
    now.beginning_of_year.must_equal Time.zone.local(now.year)
  end

  it 'should give end of a year' do
    now = Time.now
    now.end_of_year.must_equal Time.zone.local(now.year + 1) - 1.second
  end

  describe 'zone' do
    it 'should use GMT zone by default' do
      Time.zone.name.must_equal 'UTC'
    end

    it 'should be able to change timezone' do
      Time.zone = 'Europe/Warsaw'
      Time.zone.name.must_equal 'Europe/Warsaw'

      Time.zone = 'UTC'
    end
  end
end