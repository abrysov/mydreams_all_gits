require 'rails_helper'

RSpec.describe Moderate::DreamersController, type: :controller do
  describe 'moderate dreamer when sign_in as moderator' do
    let(:moderator) { create :dreamer, :moderator }
    before do
      sign_in moderator
    end

    context 'when blocking user' do
      let!(:dreamer) { create :dreamer }
      let(:find_dreamer) { Dreamer.find(dreamer.id) }
      before do
        xhr :get, :block, id: dreamer.id,
                          entity_type: 'Dreamer',
                          entity_id: dreamer.id
      end

      it('ok response') { expect(response).to be_success }
      it('is blocked') { expect(find_dreamer).to be_blocked }
      it('is approved') { expect(find_dreamer).to be_approved }
    end

    context 'when unblocking user' do
      let!(:blocked_dreamer) { create :dreamer, :blocked }
      let(:find_dreamer) { Dreamer.find(blocked_dreamer.id) }
      before do
        xhr :get, :unblock, id: blocked_dreamer.id,
                            entity_type: 'Dreamer',
                            entity_id: blocked_dreamer.id
      end

      it('ok response') { expect(response).to be_success }
      it('is unblocked') { expect(find_dreamer).not_to be_blocked }
      it('is approved') { expect(find_dreamer).to be_approved }
    end

    context 'when approve deleted or blocked' do
      let(:dreamer) { create :dreamer }
      let(:blocked_dreamer) { create :dreamer, :blocked }
      let(:deleted_dreamer) { create :dreamer, :deleted_dreamer }
      before { get :index }

      it 'should not include deleted or deleted dreamer' do
        expect(Dreamer.where(id: [dreamer.id, deleted_dreamer.id, blocked_dreamer.id])).to exist
        expect(assigns(:dreamers).where(id: [deleted_dreamer.id, blocked_dreamer.id])).not_to exist
      end
    end
  end

  describe 'moderate when sign_in as dreamer' do
    let(:dreamer) { create :dreamer }
    before do
      sign_in dreamer
      xhr :get, :block, id: dreamer.id,
                        entity_type: 'Dreamer',
                        entity_id: dreamer.id
    end
    context 'when blocking user' do
      it('redirected to sign_in') do
        expect(response).to redirect_to(new_dreamer_session_path)
      end
    end
  end
end
