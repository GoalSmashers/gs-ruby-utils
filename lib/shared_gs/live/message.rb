module GS
  module Live
    class Message
      attr_accessor :allowed_for, :event_id, :data, :source, :sticky, :data_last_updated, :timestamp

      def initialize(user, options)
        @allowed_for = options.fetch(:allowed_for, 'all')
        @event_id = options.fetch(:event_id)
        @data = options.fetch(:data, {})
        @sticky = options.fetch(:sticky, false)
        @data_last_updated = user ? user.data_changed_at.to_i : 0
        @timestamp = Time.zone.now.to_f
      end

      def to_data
        {
          allowedFor: allowed_for,
          eventId: event_id,
          data: data,
          sticky: sticky,
          dataLastUpdated: data_last_updated,
          timestamp: timestamp
        }
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
