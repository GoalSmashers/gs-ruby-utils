require 'yajl'

module GS
  module JSON
    extend self

    def parse(object, opts = {})
      Yajl::Parser.parse(object, opts)
    end

    def [](object, opts = {})
      Yajl::Encoder.encode(object, opts)
    end
  end
end
