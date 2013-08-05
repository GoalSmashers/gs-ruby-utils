module GS
  module Live
    class Message
      attr_accessor :allowed_for, :event_id, :data, :source, :sticky, :data_last_updated, :timestamp

      def initialize(user, options)
        @allowed_for = options.fetch(:allowed_for, 'all')
        @event_id = options.fetch(:event_id)
        @data = options.fetch(:data)
        # @source = options.fetch(:source)
        @sticky = options.fetch(:sticky, false)
        @data_last_updated = user.data_changed_at.to_i
        @timestamp = Time.zone.now.to_f
      end

      def ==(other)
        other.allowed_for == allowed_for &&
          other.event_id == event_id &&
          other.data == data &&
          other.timestamp == timestamp
      end
    end
  end
end
