require 'test_helper'

describe String do
  describe 'underscore' do
    it 'should correctly convert camel case to underscore' do
      'CamelCase'.underscore.must_equal 'camel_case'
      'IWantUnderscoreMethod'.underscore.must_equal 'i_want_underscore_method'
      'iWantToCheckThisAsWell'.underscore.must_equal 'i_want_to_check_this_as_well'
    end
  end

  describe 'camelize' do
    it 'should turn snake case into camel case' do
      'snake_case'.camelize.must_equal 'SnakeCase'
      'try_to_make_this_camel_case'.camelize.must_equal 'TryToMakeThisCamelCase'
      'Simple_Example'.camelize.must_equal 'SimpleExample'
    end
  end
end