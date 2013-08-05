require_relative 'message'

module GS
  module Live
    class Notifier
      def initialize
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
        msg = get(receiver)
        messages.delete(receiver.id)
        msg
      end

      def add_and_send(sender, receiver, options)
        add(receiver, options)
        process(receiver) unless receiver == sender
      end

      def send(receiver)
        process(user)
      end

      def broadcast(event_id, data = {})
        publish('all', Message.new(event_id: event_id, data: data))
      end

      protected

      def publish(channel_id, messages)
        raise NotImplementedError
        # @@publisher.write_nonblock(::JSON.generate(data) + '!.!GS_BLOCK!.!')
      end

      private

      attr_reader :messages

      # def with_events(&block)
      #   puts caller_locations.last.label
      #   block.call
      # end

      def process(receiver)
        messages = delete(receiver)
        return if messages.empty?

        publish(receiver.channel_id, messages)
      end
    end
  end
end
