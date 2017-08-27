require 'rails_helper'

RSpec.describe Account::MailController do
  describe '#index' do
    before { sign_in dreamer }
    subject { get :index }

    context 'with no conversations' do
      let(:dreamer) { create :dreamer }

      it { is_expected.to be_success }
    end

    context 'with conversations' do
      let(:message) { create :message }
      let(:dreamer) { message.sender }
      let!(:conversation) do
        create :conversation,
          messages: [message],
          member_ids: [message.sender_id, message.receiver_id]
      end

      it { is_expected.to be_success }
    end
  end
end
