module GS::Utils
  class Notifications
    cattr_accessor :messages, :publisher, :mutex, :pipe_file

    def self.add(user, options)
      @@messages[user.id] ||= []

      @@messages[user.id] << {
        allowedFor: options.delete(:allowed_for) || 'all',
        eventId: options.delete(:event_id),
        data: options.delete(:data),
        source: options[:source],
        sticky: options[:sticky] || false,
        timestamp: Time.now.to_f
      }
    end

    def self.add_and_send(by, for_user, options)
      add(for_user, options)
      process(for_user) unless for_user == by
    end

    # Gets all messages for the <user>'s channel
    def self.get(user)
      merge_notifications(user, 'opportunity:created', 'opportunities:created')

      messages = [@@messages[user.id]]
      if user.manager?
        user.subordinates.each do |subordinate|
          messages << @@messages[subordinate.id]
        end
      end
      messages.flatten.compact
    end

    def self.send(user)
      process(user)

      if user.manager?
        user.subordinates.each do |subordinate|
          process(subordinate)
        end
      elsif user.salesperson?
        process(user.manager)
      end
    end

    def self.broadcast(eventId, data = {})
      publish('all', [{ eventId: eventId, data: data }])
    end

    private

    def self.process(user)
      merge_notifications(user, 'opportunity:created', 'opportunities:created')

      return if !@@messages[user.id] || Application.env?(:test)

      user_messages = @@messages.delete(user.id)

      publish(user.channel_id, user_messages)
    end

    def self.publish(channelId, message)
      @@mutex.synchronize do
        if !@@publisher
          # Create a fifo if it does not exist
          system("mkfifo #{@@pipe_file}") unless File.exists?(@@pipe_file)

          @@publisher = Kernel.open(@@pipe_file, "w+")
          ACTIVITY_LOGGER.info("\n** Opened new pipe connection (##{@@publisher})")
        end

        @@publisher.puts(JSON.generate(authSecret: ::PUBLISHER_SECRET_KEY, channelId: channelId, message: message))
        @@publisher.flush
      end
    end

    def self.merge_notifications(owner, oldEventId, newEventId)
      old_events = (@@messages[owner.id] || []).collect { |m| m[:eventId] == oldEventId ? m : nil }.compact
      return unless old_events.length > 0

      new_event = {
        eventId: newEventId,
        allowedFor: old_events.first[:allowedFor],
        data: old_events.collect { |em| em[:data] },
        source: old_events.first[:source],
        timestamp: old_events.last[:timestamp]
      }

      first_old_index = @@messages[owner.id].index(old_events[0])
      @@messages[owner.id].insert(first_old_index, new_event)
      @@messages[owner.id] -= old_events
    end
  end

  Notifications.messages = Hash.new
  Notifications.mutex = Mutex.new
  Notifications.publisher = nil
  Notifications.pipe_file = "#{Dir.pwd}/tmp/sockets/notifications.pipe"
end