require 'test_helper'
require 'shared_gs/models/authentication_model'

class FakeUser
  attr_accessor :_store
  attr_accessor :salt, :crypted_password
  attr_accessor :memorize_token, :memorize_token_expires_at
  attr_accessor :reset_password_token, :reset_password_token_expires_at
  attr_accessor :activation_token

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

  def update(values)
    values.each do |key, value|
      self.method("#{key}=".to_sym).call(value)
    end
  end

  def save
  end
end

describe FakeUser do
  it 'should be able to calculate secure digest' do
    FakeUser.secure_digest([]).wont_equal nil
  end

  it 'should accept nil email' do
    u = FakeUser.new
    u.email = nil
    u.email.must_equal nil
  end

  it 'should turn email downcase' do
    u = FakeUser.new
    u.email = "John.Doe@dummy.com"
    u.email.must_equal "john.doe@dummy.com"
  end

  it 'should set password' do
    u = FakeUser.new
    u.password = '12345'
    u.password_confirmation.wont_equal nil
    u.salt.wont_equal nil
    u.crypted_password.wont_equal nil
  end

  it 'should set memorize token' do
    u = FakeUser.new
    u.set_memorize_token!
    u.memorize_token.wont_equal nil
    u.memorize_token_expires_at.to_i.must_equal 1.year.since.to_i
  end

  it 'should set reset password token' do
    u = FakeUser.new
    u.set_reset_token
    u.reset_password_token.wont_equal nil
    u.reset_password_token_expires_at.to_i.must_equal 2.days.since.to_i
    u.valid_reset_token?.must_equal true
  end

  it 'should set activation token' do
    u = FakeUser.new
    u.set_activation_token
    u.activation_token.wont_equal nil
  end

  it 'should reset password' do
    u = FakeUser.new
    u.set_reset_token
    u.reset_password('12345', '12345')

    u.password.must_equal '12345'
    u.password_confirmation.must_equal '12345'
    u.reset_password_token.must_equal nil
    u.reset_password_token_expires_at.must_equal nil
  end
end