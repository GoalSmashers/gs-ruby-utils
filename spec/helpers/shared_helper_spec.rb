require 'spec_helper'
require 'shared_gs/helpers/shared_helper'

include GS::Helpers

describe SharedHelper do
  include SharedHelper

  describe '#url' do
    it 'should create URL' do
      url('/test').must_equal "https://#{ENV['GS_HOST']}/test"
    end

    it 'should create URL with params' do
      url('/test', { a: 1, b: 2 }).must_equal "https://#{ENV['GS_HOST']}/test?a=1&b=2"
    end

    it 'should create URL with forced HTTP' do
      url('/test', { a: 1, b: 2 }, true).must_equal "http://#{ENV['GS_HOST']}/test?a=1&b=2"
    end
  end

  describe '#uurl' do
    it 'should create same url as #url with forced HTTP' do
      uurl('/test').must_equal url('/test', {}, true)
    end
  end
end
