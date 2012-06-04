require 'tilt'

class MailProxy
  def self.deliver(template, mail_fields = {}, ctx = {}, is_bulk = false)
    MailProxy.new.deliver_email(template, mail_fields, ctx, is_bulk)
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
        Mail.bulk_deliver(messages)
      rescue Postmark::InvalidMessageError => e
        Airbrake.notify(e)
      end
    else
      begin
        build_email(template, mail_fields, ctx).deliver
      rescue Postmark::InvalidMessageError => e
        Airbrake.notify(e)
      end
    end
  end

  # Having instance method so binding can see named routes
  def build_email(template, mail_fields = {}, ctx = {})
    template_path_and_prefix = File.join(Application.root, 'app', 'views', template)
    bound_to = self
    message = Mail.new
    attachments = mail_fields.delete(:attachments) || []
    mail_fields.each { |key, value| message[key] = value }

    # Add plain text parts
    text_view_path = "#{template_path_and_prefix}.text.plain.erb"
    if File.exists?(text_view_path)
      message.text_part = Mail::Part.new do
        body Tilt.new(text_view_path).render(bound_to, ctx: ctx)
      end
    end

    # Add HTML part
    template_path = File.join(Application.root, 'app', 'views', 'layouts', 'email.erb')
    html_view_path = "#{template_path_and_prefix}.text.html.erb"
    if File.exists?(html_view_path)
      html_body = Tilt.new(template_path).render(bound_to, ctx: ctx) do
        Tilt.new(html_view_path).render(bound_to, ctx: ctx)
      end

      message.html_part = Mail::Part.new do
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

    message
  end
end
