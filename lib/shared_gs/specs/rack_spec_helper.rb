module GS::Specs
  module RackSpecHelper
    include Rack::Test::Methods

    def redirected_to?(path)
      if path.kind_of?(Regexp)
        last_response.headers['Location'].index(path) != nil
      else
        last_response.headers['Location'].include?(path)
      end
    end

    %w(get post put delete options head).each do |m|
      define_method("x#{m}") do |uri, params = {}, env = {}, &block|
        @json_body = nil
        method(m).call(uri, params, env.merge({ 'HTTP_X_REQUESTED_WITH' => 'XMLHttpRequest' }), &block)
      end
    end

    def status
      last_response.status
    end

    def body
      if @json_body || (last_response.content_type =~ /application\/json/) != nil
        @json_body = JSON.parse(last_response.body) unless @json_body
        @json_body
      else
        last_response.body
      end
    end

    def headers
      last_response.headers
    end
  end
end
