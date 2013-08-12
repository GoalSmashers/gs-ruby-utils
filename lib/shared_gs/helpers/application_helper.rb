module GS
  module Helpers
    module ApplicationHelper
      # Browser version testers
      def ie?(version)
        (request.user_agent =~ %r(MSIE #{version})) != nil
      end

      def chrome_frame?
        (request.user_agent =~ /chromeframe/) != nil
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
