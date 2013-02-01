require 'test_helper'
require 'shared_gs/helpers/shared_helpers'

include GS::Helpers

describe SharedHelpers do
  include SharedHelpers

  describe '#url' do
    it 'should create URL' do
      url('/test').must_equal "https://#{HOST}/test"
    end

    it 'should create URL with params' do
      url('/test', { a: 1, b: 2 }).must_equal "https://#{HOST}/test?a=1&b=2"
    end

    it 'should create URL with forced HTTP' do
      url('/test', { a: 1, b: 2 }, true).must_equal "http://#{HOST}/test?a=1&b=2"
    end
  end

  describe '#uurl' do
    it 'should create same url as #url with forced HTTP' do
      uurl('/test').must_equal url('/test', {}, true)
    end
  end
end