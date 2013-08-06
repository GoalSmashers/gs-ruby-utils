require_relative 'notifier'

module GS
  module Live
    class RedisNotifier < Notifier
      def initialize(redis)
        super
        @redis = redis
      end

      private

      attr_reader :redis

      CHANNEL = 'gs-live'

      def publish(channel_id, data)
        redis.publish(CHANNEL, { channel_id: channel_id, data: data }.to_json)
      end
    end
  end
end
