require 'test_helper'

describe String do
  describe 'underscore' do
    it 'should correctly convert camel case to underscore' do
      'CamelCase'.underscore.must_equal 'camel_case'
      'IWantUnderscoreMethod'.underscore.must_equal 'i_want_underscore_method'
      'iWantToCheckThisAsWell'.underscore.must_equal 'i_want_to_check_this_as_well'
    end
  end
end