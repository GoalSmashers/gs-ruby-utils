require 'shared_gs/mail/mail_proxy'

module GS
  module Mail
    class GenericMailer < MailProxy
      def self.from_name
        'Dummy Name'
      end

      def self.from_address
        'generic@address.com'
      end

      def self.path
        self.to_s.underscore
      end

      def self.deliver(template, ctx = {})
        mailer = self.new
        method = template.to_s.split('/').first.to_sym
        mail_fields = mailer.method(method).call(ctx).merge(
          from: "#{from_name} <#{from_address}>",
          sent_on: Time.now.to_s,
          charset: 'UTF-8',
          content_transfer_encoding: "8bit"
        )
        mail_fields[:to] = ctx[:to] || from_address unless mail_fields[:to]
        if ctx[:subject]
          mail_fields[:subject] = ctx[:subject]
        else
          ctx[:subject] = mail_fields[:subject]
        end

        mailer.deliver_email("#{path}/#{template}", mail_fields, ctx, mail_fields[:to].kind_of?(Array))
      end
    end
  end
end
