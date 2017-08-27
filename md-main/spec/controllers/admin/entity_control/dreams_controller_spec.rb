require 'rails_helper'

RSpec.describe Admin::EntityControl::DreamsController do
  describe 'some crud tests' do
    let(:dreamer) { create :dreamer, role: 'admin' }
    let(:dream) { create :dream }
    before { sign_in dreamer }

    describe '#index' do
      subject { get :index }

      it { is_expected.to be_success }
    end

    describe '#show' do
      subject { get :show, id: dream.id }

      it { is_expected.to be_success }
    end

    describe '#update' do
      subject { patch :update, id: dream.id, dream: { title: 'new title' } }

      it { is_expected.to be_success }
    end

    describe '#delete' do
      before { delete :destroy, id: dream.id }

      it { expect(response).to redirect_to(action: :index) }
      it { expect(Dream.count).to eq(0) }
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
