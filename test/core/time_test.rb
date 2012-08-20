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

  it 'should give noon' do
    now = Time.now
    now.noon.must_equal Time.local(now.year, now.month, now.day)
  end

  it 'should give beginning of a month' do
    now = Time.now
    now.beginning_of_month.must_equal Time.local(now.year, now.month)
  end

  it 'should give end of a month' do
    now = Time.now
    now.end_of_month.must_equal Time.local(now.year, now.month) - 1.second
  end
end