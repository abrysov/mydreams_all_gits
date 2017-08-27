require 'rails_helper'

RSpec.describe Admin::EntityControl::DreamersController do
  describe 'some crud tests' do
    let(:admin) { create :dreamer, role: 'admin' }
    let(:dreamer) { create :dreamer }
    before { sign_in admin }

    describe '#index' do
      subject { get :index }

      it { is_expected.to be_success }
    end

    describe '#show' do
      subject { get :show, id: dreamer.id }

      it { is_expected.to be_success }
    end

    describe '#update' do
      subject { patch :update, id: dreamer.id, dreamer: { first_name: 'new title' } }

      it { is_expected.to be_success }
    end

    describe '#delete' do
      before { delete :destroy, id: dreamer.id }

      it { expect(response).to redirect_to(action: :index) }
      it { expect(Dreamer.find_by(id: dreamer.id)).to be_nil }
    end
  end

  describe 'when go to admin as general dreamer' do
    let(:dreamer) { create :dreamer, role: 'user' }
    before do
      sign_in dreamer
      get :index
    end

    it('redirected to sign_in') do
      expect(response).to redirect_to(new_dreamer_session_path)
    end
  end
end
