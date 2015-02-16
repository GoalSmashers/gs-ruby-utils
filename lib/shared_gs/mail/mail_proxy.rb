require 'tilt'

module GS
  module Mail
    class MailProxy
      def root
        Application.root
      end

      def mail_view_prefix(template)
        File.join(root, 'app', 'views', template.to_s)
      end

      def template_path
        File.join(root, 'app', 'views', 'layouts', "#{self.class.to_s.underscore}.erb")
      end

      def self.deliver(template, mail_fields = {}, ctx = {}, is_bulk = false)
        self.new.deliver_email(template, mail_fields, ctx, is_bulk)
      end

      def deliver_email(template, mail_fields = {}, ctx = {}, is_bulk = false)
        if is_bulk
          messages = ctx[:to].collect do |address|
            fields_copy = mail_fields.dup
            ctx_copy = ctx.dup
            fields_copy[:to] = ctx_copy[:to] = address
            build_email(template, fields_copy, ctx_copy)
          end

          begin
            ::Mail.bulk_deliver(messages)
          rescue Exception => e
            Bugsnag.notify(e)
          end
        else
          begin
            build_email(template, mail_fields, ctx).deliver
          rescue Exception => e
            Bugsnag.notify(e)
          end
        end
      end

      # Having instance method so binding can see named routes
      def build_email(mail_view, mail_fields = {}, ctx = {})
        mail_path_and_prefix = mail_view_prefix(mail_view)
        bound_to = self
        message = ::Mail.new
        attachments = mail_fields.delete(:attachments) || []
        mail_fields.each { |key, value| message[key] = value }

        # Add plain text parts
        text_view_path = "#{mail_path_and_prefix}.text.plain.erb"
        if File.exists?(text_view_path)
          message.text_part = ::Mail::Part.new do
            body Tilt.new(text_view_path).render(bound_to, ctx: ctx)
          end
        end

        # Add HTML part
        html_view_path = "#{mail_path_and_prefix}.text.html.erb"
        if File.exists?(html_view_path)
          html_body = Tilt.new(template_path).render(bound_to, ctx: ctx) do
            Tilt.new(html_view_path).render(bound_to, ctx: ctx)
          end

          message.html_part = ::Mail::Part.new do
            content_type "text/html; charset=UTF-8"
            body html_body
          end
        end

        # Add attachments
        message.postmark_attachments = attachments.collect do |name, data|
          {
            "Name" => name,
            "Content" => [data[:content]].pack("m"),
            "ContentType" => data[:mime_type]
          }
        end

        # Set encoding explicetely
        message.parts.each { |p| p.charset = 'UTF-8' }

        message
      end
    end
  end
end
