module GS
  module Helpers
    module ApplicationHelper
      # Browser version testers
      def ie7?
        request.user_agent =~ /MSIE 7/
      end

      def ie8?
        request.user_agent =~ /MSIE 8/
      end

      def chrome_frame?
        request.user_agent =~ /chromeframe/
      end

      # CSRF helpers
      def csrf_tag
        Rack::Csrf.tag(env) unless Application.env?(:test)
      end

      def csrf_token
        Rack::Csrf.token(env) unless Application.env?(:test)
      end
    end
  end
end
