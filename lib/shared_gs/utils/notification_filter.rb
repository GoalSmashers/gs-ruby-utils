# We use after filter as Rack Middleware so it does not get included multiple times via inheritance
# and don't run before requests as Filters are included as first app in config.ru
class NotificationFilter
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)

    user = find_user(env)
    if user && env['HTTP_X_REQUESTED_WITH'] == 'XMLHttpRequest' && !headers['Content-Disposition'] && extra_checks
      # Attach events to current response
      if status >= 200 && status < 299
        old_body = body.join
        new_body = {
          original: {
            body: old_body,
            type: headers['Content-Type']
          },
          events: Notifications.get(user)
        }
        new_body = JSON.generate(new_body)
        body.clear
        body << new_body

        headers['Content-Type'] = "application/json;charset=utf-8"
        headers['X-With-Events'] = '1'
        headers['Content-Length'] = new_body.dup.force_encoding('ascii').length.to_s
      end
    end

    # Send events nonetheless
    Notifications.send(user) if user

    [status, headers, body]
  end

  def extra_checks
    true
  end

  def find_user(env)
    env['warden'] && env['warden'].user
  end
end
