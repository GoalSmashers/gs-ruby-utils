require_relative 'notifier'
require_relative '../utils/json'

module GS
  module Live
    class RedisNotifier < Notifier
      def initialize(redis)
        super
        @redis = redis
      end

      protected

      def build_message(channel_id, data)
        raise NotImplementedError
      end

      private

      attr_reader :redis

      CHANNEL = 'gs-live'

      def publish(*args)
        redis.publish(CHANNEL, GS::JSON[build_message(*args)])
      end
    end
  end
end
