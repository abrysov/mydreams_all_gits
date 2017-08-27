require 'rails_helper'

RSpec.describe BuildMessage do
  describe '.call' do
    let(:sender) { create :dreamer }
    let(:receiver) { create :dreamer }
    let(:params) { { message: generate(:string) } }
    subject { described_class.call(from: sender, to: receiver, message_params: params) }

    it 'builds message with conversation' do
      expect(subject.conversation).not_to be nil
    end
    it 'builds message with correct sender' do
      expect(subject.sender).to eq sender
    end
    it 'builds message with correct receiver' do
      expect(subject.receiver_id).to eq receiver.id
    end
    it 'builds message with correct message body' do
      expect(subject.message).to eq params[:message]
    end
  end
end
