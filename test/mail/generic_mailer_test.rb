require 'test_helper'

class GenericMailer < GS::Mail::GenericMailer
  def demo(ctx = {})
    { subject: "Generic Subject" }
  end
end

describe GenericMailer do
  include FlexMock::TestCase

  describe 'deliver' do
    it 'should handle default options' do
      verify_mail_fields = lambda do |args|
        args.length == 6 && \
          args[:to] == GenericMailer.from_address && \
          args[:from] == "#{GenericMailer.from_name} <#{GenericMailer.from_address}>" && \
          args[:charset] == 'UTF-8' && \
          args[:sent_on] != nil && \
          args[:content_transfer_encoding] == '8bit'
      end

      verify_ctx = lambda do |args|
        args.length == 1 && args[:subject] == "Generic Subject"
      end

      flexmock(GenericMailer)
        .new_instances
        .should_receive(:deliver_email)
        .with('generic_mailer/demo', on { |args| verify_mail_fields.call(args) }, on { |args| verify_ctx.call(args) }, false)
        .once
        .and_return(true)

      GenericMailer.deliver(:demo)
    end

    it 'should add to option' do
      to = Sham.email

      flexmock(GenericMailer)
        .new_instances
        .should_receive(:deliver_email)
        .with('generic_mailer/demo', on { |args| args[:to] == to }, any, false)
        .once
        .and_return(true)

      GenericMailer.deliver(:demo, { to: to })
    end

    it 'should pass context' do
      ctx = {
        to: Sham.email,
        x1: 1,
        x2: 5
      }

      flexmock(GenericMailer)
        .new_instances
        .should_receive(:deliver_email)
        .with('generic_mailer/demo', on { |args| args[:to] == ctx[:to] }, on { |args| args[:x1] == 1 && args[:x2] == 5 }, false)
        .once
        .and_return(true)

      GenericMailer.deliver(:demo, ctx)
    end

    it 'should send bulk emails' do
      to = [Sham.email, Sham.email]

      flexmock(GenericMailer)
        .new_instances
        .should_receive(:deliver_email)
        .with('generic_mailer/demo', any, any, true)
        .once
        .and_return(true)

      GenericMailer.deliver(:demo, { to: to })
    end
  end
end