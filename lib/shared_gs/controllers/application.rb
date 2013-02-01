module GS::Controllers
  module Application
    def self.included(klass)
      klass.extend(GS::Controllers::ApplicationClass)
    end

    def json(data)
      content_type :json
      data.kind_of?(Symbol) ?
        erb(data) :
        JSON.generate(data)
    end
  end

  module ApplicationClass
    def env
      environment
    end

    def env?(*patterns)
      patterns.any? do |pattern|
        environment == pattern.to_sym
      end
    end
  end
end