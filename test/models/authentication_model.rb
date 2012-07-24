require 'test_helper'

class FakeUser
  attr_accessor :_store

  include GS::Models::AuthenticationModel

  def initialize
    @_store = {}
  end

  def []=(key, value)
    @_store[key] = value
  end

  def method_missing(name, *args)
    @_store[name]
  end
end

describe FakeUser do
  it 'should be able to calculate secure digest' do
    FakeUser.secure_digest([]).wont_equal nil
  end

  it 'should turn email downcase' do
    u = FakeUser.new
    u.email = "John.Doe@dummy.com"
    u.email.must_equal "john.doe@dummy.com"
  end
end