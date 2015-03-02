require 'yajl'

module GS
  module JSON
    extend self

    def parse(object)
      Yajl::Parser.parse(object)
    end

    def [](object)
      Yajl::Encoder.encode(object)
    end
  end
end
