require 'spec_helper'
require 'shared_gs/live/notifier'

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

  describe '#add_and_send' do
    it 'should add and send' do
      flexmock(Sender)
        .should_receive(:run)
        .with(receiver.channel_id, Array)

      @notifier.add_and_send(sender, receiver, data)
      @notifier.get(sender).must_equal []
      @notifier.get(receiver).must_equal [msg]
    end

    it 'should add but not send if sender is receiver' do
      flexmock(Sender)
        .should_receive(:run)
        .never

      @notifier.add_and_send(receiver, receiver, data)
      @notifier.get(receiver).must_equal [msg]
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
