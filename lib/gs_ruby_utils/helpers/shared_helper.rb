module GS
  module Helpers
    module SharedHelper
      def url(action, params = {}, force_http = false)
        params = params.collect { |k, v| "#{k}=#{v}" }.join('&')
        %{http#{Application.env?(:development) || force_http ? '' : 's'}://#{ENV['GS_HOST']}#{action}#{params.length > 0 ? "?" + params : ''}}
      end

      def uurl(action, params = {})
        url(action, params, true)
      end
    end
  end
end
