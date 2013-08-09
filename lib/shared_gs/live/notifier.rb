require_relative 'message'

module GS
  module Live
    class Notifier
      def initialize(*args)
        @messages = {}
      end

      def add(receiver, options)
        messages[receiver.id] ||= []
        messages[receiver.id] << Message.new(receiver, options)
      end

      def get(receiver)
        messages.fetch(receiver.id, [])
      end

      def delete(receiver)
        msgs = get(receiver)
        messages.delete(receiver.id)
        msgs
      end

      def add_and_send(sender, receiver, options)
        add(receiver, options)
        process(receiver) unless receiver == sender
      end

      def send(receiver)
        process(receiver)
      end

      def broadcast(event_id, data = {})
        publish('all', [Message.new(nil, event_id: event_id, data: data).to_data])
      end

      protected

      def publish(channel_id, data)
        raise NotImplementedError
      end

      private

      attr_reader :messages

      def process(receiver)
        messages = delete(receiver)
        return if messages.empty?

        publish(receiver.channel_id, messages.collect(&:to_data))
      end
    end
  end
end
