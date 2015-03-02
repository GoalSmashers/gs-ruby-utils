module GS
  module Utils
    class TScoped
      attr_reader :scope

      def initialize(*scope)
        @scope = scope
      end

      def t(key, substitutes = {})
        I18n.t(key, substitutes.merge(scope: @scope))
      end
    end
  end
end
