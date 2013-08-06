require 'spec_helper'
require 'shared_gs/live/redis_notifier'

describe GS::Live::RedisNotifier do
  include FlexMock::TestCase

  before do
    Timecop.freeze
    @notifier = GS::Live::RedisNotifier.new(redis)
  end

  after do
    Timecop.return
  end

  describe '#send' do
    it 'should publish data via Redis#publish' do
      redis
        .should_receive(:publish)
        .once
        .with('gs-live', { channel_id: receiver.channel_id, data: [msg.to_data] }.to_json)

      @notifier.add(receiver, data)
      @notifier.send(receiver)
    end
  end

  private

  def data
    { event_id: 'test', data: {} }
  end

  def msg
    @_message ||= GS::Live::Message.new(receiver, data)
  end

  def receiver
    @_receiver = flexmock('User', id: 1, data_changed_at: Time.now, channel_id: 1)
  end

  def redis
    @_redis ||= flexmock(Redis)
  end
end
