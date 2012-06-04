require 'test_helper'

describe Time do
  it 'should process to_json' do
    now = Time.now
    zone = now.strftime('%z')

    now.to_json.must_equal now.strftime('%FT%R:%S') + "#{zone[0..2]}:#{zone[3..-1]}"
  end
end