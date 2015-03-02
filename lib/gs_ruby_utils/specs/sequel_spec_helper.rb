module GS
  module Specs
    module Sequel
      class << self
        def truncate_all
          clean_query = "truncate " + ::Sequel::Model.db.tables.delete_if { |n| n =~ /schema/ }.join(', ')
          ::Sequel::Model.db.execute(clean_query)
        end
      end
    end
  end
end
