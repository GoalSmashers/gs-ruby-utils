require 'sinatra'
require 'sinatra/namespace'

class EmailPreview < Sinatra::Base
  register Sinatra::Namespace

  def self.from
    'info@goalsmashers.com'
  end

  def self.mailer
    GenericMailer
  end

  def self.path
    "/#{mailer.to_s.underscore}"
  end

  namespace path do
    # Example
    # get '/account_limit_hit*' do
    #   prepare_email do
    #     {
    #       name_or_email: Sham.first_name,
    #       limit: 10
    #     }
    #   end
    # end
  end

  private

  def prepare_email(&block)
    resource, type = request.path.split("#{self.class.path}/").last.split('.')
    preview_mailer = self.class.mailer.new
    email_info = {
      from: self.class.from,
      to: Sham.email
    }
    context = yield

    begin
      method = resource.split('/').first.to_sym
      email_info.merge!(preview_mailer.method(method).call(context))
      context[:subject] = email_info[:subject]
    rescue Exception => e
      # swallow
    end

    mail = preview_mailer.build_email("#{preview_mailer.class.to_s.underscore}/#{resource}", email_info, context)
    template = Tilt::ERBTemplate.new { |t| layout }
    template.render(Object.new, {
      url: request.url,
      mail: mail,
      type: type,
      body_part: type == 'html' ? mail.html_part : mail.text_part
    })
  end

  def layout
    <<-LAYOUT
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=<%= body_part.charset %>" />
</head>
<style type="text/css">
  #message_headers {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    height: 85px;
    padding: 10px 0 0 0;
    margin: 0;
    background: #fff;
    font-size: 12px;
    font-family: "Lucida Grande";
    border-bottom: 1px solid #dedede;
    overflow: hidden;
  }

  #message_headers dl {
    margin: 0;
    padding: 0;
  }

  #message_headers dt {
    width: 60px;
    padding: 1px;
    float: left;
    text-align: right;
    font-weight: bold;
    color: #7f7f7f;
  }

  #message_headers dd {
    margin-left: 70px;
    padding: 1px;
  }

  #message_headers p.alternate {
    position: absolute;
    top: 0;
    right: 15px;
  }

  #message_headers p.alternate a {
    color: #09c;
  }

  #message_body {
    position: fixed;
    top: 95px;
    bottom: 0;
    left: 0;
    right: 0;
    overflow: auto;
  }

  pre#message_body {
    padding: 10px;
    white-space: pre-wrap;
  }
</style>
<div id="message_headers">
  <dl>
    <dt>From:</dt>
    <dd><%= mail.from %></dd>

    <dt>Subject:</dt>
    <dd><strong><%= mail.subject %></strong></dd>

    <dt>Date:</dt>
    <dd><%= Time.now.strftime("%b %e, %Y %I:%M:%S %p %Z") %></dd>

    <dt>To:</dt>
    <dd><%= mail.to.join(', ') %></dd>
  </dl>

  <% if mail.multipart? %>
    <p class="alternate">
      <% if type == 'html' %>
        <a href="<%= url.sub(/html$/, 'txt') %>">View plain text version</a>
      <% else %>
        <a href="<%= url.sub(/txt$/, 'html') %>">View HTML version</a>
      <% end %>
    </p>
  <% end %>
</div>

<% if type == 'html' %>
  <div id="message_body"><%= body_part.body %></div>
<% else %>
  <pre id="message_body"><%= body_part.body %></pre>
<% end %>
    LAYOUT
  end
end