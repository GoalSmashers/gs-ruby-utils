class SequelUtils
  def self.include
    Sequel.class_eval do
      plugin :association_dependencies
      plugin :timestamps, update_on_create: true
      plugin :touch
      plugin :json_serializer
      plugin :validation_helpers
      plugin :force_encoding, 'UTF-8'

      def self.plain_dataset
        db[table_name]
      end
    end
  end
end
