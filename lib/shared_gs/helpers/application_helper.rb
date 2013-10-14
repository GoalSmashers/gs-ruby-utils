require 'shared_gs/utils/assets'
require 'shared_gs/utils/t_scoped'

module GS
  module Helpers
    module ApplicationHelper
      # Layouts
      def lerb(template, options = {})
        @action = template.to_s.split('/')[1].gsub(/[\W_]/, '') if template.kind_of?(Symbol)
        erb(template, options.merge(layout: flash[:layout]))
      end

      # Flash
      def flash
        request.env['gs-flash'] ||= {}
      end

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

      # I18n
      def t(key, options = {})
        I18n.t(key, options)
      end

      def t_scoped(*scope)
        GS::Utils::TScoped.new(scope)
      end

      # Assets
      %w(bundle bundles inline_bundle).each do |name|
        define_method(name) { |*args| GS::Utils::Assets.public_send(name, *args) }
      end

      def loading_mode?(mode)
        (env?(:development) || ie?(8) || ie?(9)) ? false : mode
      end
    end
  end
end
