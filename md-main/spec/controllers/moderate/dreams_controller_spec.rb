require 'rails_helper'

RSpec.describe Moderate::DreamsController, type: :controller do
  describe 'moderate dreamer when sign_in as moderator' do
    let(:moderator) { create :dreamer, :moderator }
    before do
      sign_in moderator
    end

    context 'when approve deleted or blocked dreams' do
      let(:dreamer) { create :dreamer }
      let(:blocked_dreamer) { create :dreamer, :blocked }
      let(:deleted_dreamer) { create :dreamer, :deleted_dreamer }

      let(:dream) { create :dream, dreamer: dreamer }
      let(:deleted_dream) { create :dream, :deleted, dreamer: dreamer }
      let(:dream_of_deleted_dreamer) { create :dream, dreamer: deleted_dreamer }
      let(:dream_of_blocked_dreamer) { create :dream, dreamer: blocked_dreamer }

      it 'should not include deleted or deleted dreamer' do
        get :index
        bad_dream_ids = [dream_of_deleted_dreamer, dream_of_blocked_dreamer].map(&:id)
        expect(Dream.where(id: [dream.id, deleted_dream.id])).to exist
        expect(assigns(:dreams).where(id: bad_dream_ids)).not_to exist
      end
    end
  end
end
