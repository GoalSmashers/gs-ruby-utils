require 'spec_helper'

require 'shared_gs/utils/scoped_backend'

describe ScopedBackend do
  before do
    @backend = ScopedBackend.new
    @backend.send(:load_file, File.expand_path('spec/data/i18n-test.yml'))
  end

  it 'must get normal translation' do
    translate('common.add_another').must_equal 'add another'
  end

  it 'must get scoped translations' do
    translate('common.all').must_equal 'All'
    translate('common.authenticate').must_equal 'Confirm identity'
  end

  it 'must get (gs) scope' do
    @backend.scoped_translations('en', :gs).must_equal(
      'common.accept' => 'Accept',
      'common.activations' => 'activation activations',
      'common.all' => 'All',
      'common.authenticate' => 'Confirm identity'
    )
  end

  it 'must get (gw) scope' do
    @backend.scoped_translations('en', :gw).must_equal('common.authenticate' => 'Confirm identity')
  end

  it 'must get overriden (de) translation' do
    @backend.scoped_translations('en', :de).must_equal('common.label' => 'Desktop')
  end

  it 'must get overriden (de) translation' do
    @backend.scoped_translations('en', :mo).must_equal('common.label' => 'Mobile')
  end

  it 'must get a list' do
    @backend.scoped_translations('en', :xx).must_equal('common.options' => ['a', 'b'])
  end

  private

  def translate(key)
    @backend.translate('en', key)
  end
end
