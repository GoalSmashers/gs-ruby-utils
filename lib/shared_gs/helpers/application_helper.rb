module GS::Helpers
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
  end
end