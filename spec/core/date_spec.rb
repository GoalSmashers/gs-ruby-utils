require 'spec_helper'

describe Date do
  it 'should process to_json' do
    date = Date.new(2012)
    zone = date.strftime('%z')

    date.to_json.must_equal "\"#{date.strftime('%F')}\""
  end

  it 'should correctly serialize and deserialize date' do
    date = Date.new(2012)
    json = JSON[{ created_at: date }]
    JSON.parse(json)['created_at'].must_equal date.iso8601.to_s
  end
end
