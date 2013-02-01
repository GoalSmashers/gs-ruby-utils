require 'test_helper'
require 'shared_gs/controllers/email_preview'

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

  namespace path do
    get '/demo*' do
      prepare_email do
        {}
      end
    end
  end
end

describe EmailPreview do
  include GS::Tests::ControllerTestHelpers
  include FlexMock::TestCase

  def app
    app_for(MyEmailPreview)
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
            to: [Sham.email],
            from: Sham.email,
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
      body.include?('!!HTML!!').must_equal true
    end

    it 'should get text version' do
      flexmock(MyMailer)
        .new_instances
        .should_receive(:build_email)
        .once
        .with('my_mailer/demo', any, any)
        .and_return(
          flexmock({
            to: [Sham.email],
            from: Sham.email,
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
      body.include?('!!TEXT!!').must_equal true
    end
  end
end