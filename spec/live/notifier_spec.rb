require 'spec_helper'
require 'gs_ruby_utils/live/notifier'

class Sender
  def self.run(*args); end
end

class FakeNotifier < GS::Live::Notifier
  def publish(*args)
    Sender.run(*args)
  end
end

describe FakeNotifier do
  include FlexMock::TestCase

  before do
    Timecop.freeze
    @notifier = FakeNotifier.new
  end

  after do
    Timecop.return
  end

  describe '#add' do
    it 'should add a message' do
      @notifier.add(receiver, data)
      @notifier.get(receiver).must_equal [msg]
    end

    it 'should add 5 messages' do
      5.times do
        @notifier.add(receiver, data)
      end

      @notifier.get(receiver).must_equal [msg] * 5
    end
  end

  describe '#get' do
    it 'should get no messages' do
      @notifier.get(receiver).must_equal []
    end

    it 'should get a message twice' do
      @notifier.add(receiver, data)
      @notifier.get(receiver).must_equal @notifier.get(receiver)
    end
  end

  describe '#delete' do
    it 'should delete even if no data added' do
      @notifier.delete(receiver).must_equal []
    end

    it 'should delete added one' do
      @notifier.add(receiver, data)
      @notifier.delete(receiver).must_equal [msg]
    end
  end

  describe '#add_and_send' do
    it 'should add and send' do
      flexmock(Sender)
        .should_receive(:run)
        .with(receiver.channel_id, [msg.to_data])

      @notifier.add_and_send(sender, receiver, data)
      @notifier.get(sender).must_equal []
      @notifier.get(receiver).must_equal []
    end

    it 'should add but not send if sender is receiver' do
      flexmock(Sender)
        .should_receive(:run)
        .never

      @notifier.add_and_send(receiver, receiver, data)
      @notifier.get(receiver).must_equal [msg]
    end
  end

  describe '#send' do
    it 'should not send if no messages' do
      flexmock(Sender)
        .should_receive(:run)
        .never

      @notifier.send(receiver)
    end

    it 'should send all messages if available' do
      flexmock(Sender)
        .should_receive(:run)
        .with(receiver.channel_id, [msg.to_data])

      @notifier.add(receiver, data)
      @notifier.send(receiver)
    end
  end

  describe '#broadcast' do
    it 'should broadcast message to all' do
      flexmock(Sender)
        .should_receive(:run)
        .with('all', [GS::Live::Message.new(nil, data).to_data])

      @notifier.broadcast(data[:event_id], data[:data])
    end
  end

  private

  def data
    { event_id: 'test', data: {} }
  end

  def msg
    @_message ||= GS::Live::Message.new(receiver, data)
  end

  def sender
    @_sender ||= flexmock('User', id: 0, data_changed_at: Time.now)
  end

  def receiver
    @_receiver ||= flexmock('User', id: 1, data_changed_at: Time.now, channel_id: 1)
  end
end
