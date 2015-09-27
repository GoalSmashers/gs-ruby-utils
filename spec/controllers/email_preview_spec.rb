require 'spec_helper'
require 'gs_ruby_utils/controllers/email_preview'

include GS::Controllers

class MyMailer < GS::Mail::GenericMailer
  def demo(ctx = {})
    {}
  end
end

class MyEmailPreview < EmailPreview
  def self.mailer
    MyMailer
  end

  preview :demo do
    {}
  end
end

describe MyEmailPreview do
  include GS::Specs::ControllerSpecHelper
  include FlexMock::TestCase

  def app
    app_for(MyEmailPreview)
  end

  describe '/my_mailer' do
    it 'should get preview all' do
      get '/my_mailer'
      status.must_equal 200
    end

    it 'should get list of previews' do
      get '/my_mailer/_list'
      status.must_equal 200
      body.must_include '/my_mailer/demo'
    end
  end

  describe '/my_mailer/demo' do
    it 'should get HTML version' do
      flexmock(MyMailer)
        .new_instances
        .should_receive(:build_email)
        .once
        .with('my_mailer/demo', any, any)
        .and_return(
          flexmock({
            to: [Fabricate.sequence(:email)],
            from: Fabricate.sequence(:email),
            'multipart?' => false,
            subject: 'subject',
            html_part: flexmock({
              charset: 'UTF-8',
              body: '!!HTML!!'
            }),
           text_part: nil
          })
        )

      get '/my_mailer/demo.html'
      status.must_equal 200
      body.must_include '!!HTML!!'
    end

    it 'should get text version' do
      flexmock(MyMailer)
        .new_instances
        .should_receive(:build_email)
        .once
        .with('my_mailer/demo', any, any)
        .and_return(
          flexmock({
            to: [Fabricate.sequence(:email)],
            from: Fabricate.sequence(:email),
            'multipart?' => false,
            subject: 'subject',
            html_part: nil,
            text_part: flexmock({
              charset: 'UTF-8',
              body: '!!TEXT!!'
            })
          })
        )

      get '/my_mailer/demo.txt'
      status.must_equal 200
      body.must_include '!!TEXT!!'
    end
  end
end
