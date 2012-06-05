class Sequel::Model
  def self.cleanup
    clean_query = "truncate " + self.db.tables.delete_if { |n| n =~ /schema/ }.join(', ')
    self.db.execute(clean_query)
  end
end
