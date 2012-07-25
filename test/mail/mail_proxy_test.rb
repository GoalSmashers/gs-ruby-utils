require 'test_helper'

class MailProxy
  def root
    Dir.pwd
  end
end

class Airbrake
  def self.notify(e)
  end
end

describe MailProxy do
  include FlexMock::TestCase

  it 'should get mail view prefix' do
    MailProxy.new.mail_view_prefix('mail_proxy/demo').must_equal "#{Dir.pwd}/app/views/mail_proxy/demo"
  end

  it 'should get template path' do
    MailProxy.new.template_path.must_equal "#{Dir.pwd}/app/views/layouts/mail_proxy.erb"
  end

  describe 'static deliver' do
    it 'should forward to instance' do
      flexmock(MailProxy)
        .new_instances
        .should_receive(:deliver_email)
        .once
        .with(:test, { a: 1 }, { b: 2 }, false)
        .and_return(true)

      MailProxy.deliver(:test, { a: 1 }, { b: 2 })
    end
  end

  describe '#deliver' do
    it 'should call build_email and deliver' do
      message = Mail.new
      address = Sham.email

      flexmock(MailProxy)
        .new_instances
        .should_receive(:build_email)
        .once
        .with(:test, { to: address }, { subject: "Just testing" })
        .and_return(message)
      flexmock(message)
        .should_receive(:deliver)
        .once

      MailProxy.deliver(:test, { to: address }, { subject: "Just testing" })
    end

    it 'should call airbrake in case of an error' do
      error = Postmark::InvalidMessageError.new
      message = Mail.new

      flexmock(MailProxy)
        .new_instances
        .should_receive(:build_email)
        .once
        .and_return(message)
      flexmock(message)
        .should_receive(:deliver)
        .once
        .and_raise(error)
      flexmock(Airbrake)
        .should_receive(:notify)
        .once
        .with(error)

      MailProxy.deliver(:test)
    end

    it 'should send bulk emails' do
      to = [Sham.email, Sham.email]
      subject = "Test email"
      message = Mail.new

      flexmock(MailProxy)
        .new_instances
        .should_receive(:build_email)
        .twice
        .and_return(message)
      flexmock(message)
        .should_receive(:deliver)
        .never
      flexmock(Mail)
        .should_receive(:bulk_deliver)
        .once
        .with(on do |messages|
          messages.length == 2
        end)

      MailProxy.deliver(:test, {}, { to: to, subject: subject }, true)
    end

    it 'should pass correct :to when doing bulk emails' do
      to = [Sham.email]

      flexmock(MailProxy)
        .new_instances
        .should_receive(:build_email)
        .once
        .with(:test, hsh(to: to[0]), hsh(to: to[0]))
        .and_return(true)

      MailProxy.deliver(:test, {}, { to: to }, true)
    end
  end
end