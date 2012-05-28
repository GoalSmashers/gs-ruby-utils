class UAFilter
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)

    if env['HTTP_USER_AGENT'] && (ua = env['HTTP_USER_AGENT'].match(/MSIE [789]/))
      if ua[0] == 'MSIE 7'
        headers['X-UA-Compatible'] = 'chrome=1'
      elsif ua[0] == 'MSIE 8'
        headers['X-UA-Compatible'] = 'IE=EmulateIE8,chrome=1'
      else
        headers['X-UA-Compatible'] = 'IE=EmulateIE9,chrome=1'
      end
    end

    [status, headers, body]
  end
end