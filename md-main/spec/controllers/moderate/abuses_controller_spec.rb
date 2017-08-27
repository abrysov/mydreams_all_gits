require 'rails_helper'

RSpec.describe Moderate::AbusesController, type: :controller do
  describe 'create Abuse' do
    let!(:project_moderator) { create :dreamer, :moderator }
    let(:entity) { create(:dreamer) }
    let(:moderator) { create :dreamer, :moderator }
    let(:abuse_params) do
      {
        abusable_type: entity.class.to_s,
        abusable_id: entity.id,
        text: '123'
      }
    end
    before do
      sign_in moderator
      xhr :post, :create, abuse: abuse_params
    end

    it 'ok response' do
      expect(response).to be_success
    end

    it 'store Abuse in db' do
      expect(Abuse.where(abuse_params)).to exist
    end

    it 'sends a message to suspected Dreamer' do
      expect(
        Message.where(
          receiver_id: entity.id,
          sender_id: project_moderator.id
        )
      ).to exist
    end

    it 'create ModeratorLogs' do
      expect(
        ModeratorLog.where(
          dreamer_id: moderator.id,
          action: 'create'
        )
      ).to exist
    end
  end
end
