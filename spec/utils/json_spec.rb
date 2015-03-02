require 'spec_helper'
require 'gs_ruby_utils/utils/json'

describe GS::JSON do
  describe '#parse' do
    it 'should parse JSON' do
      GS::JSON.parse("[1,2,3]").must_equal [1, 2, 3]
    end
  end

  describe '#[]' do
    it 'should encode JSON' do
      GS::JSON[{ a: 1 }].must_equal '{"a":1}'
    end
  end
end
