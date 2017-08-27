require 'rails_helper'

RSpec.describe Admin::EntityControl::TopDreamsController do
  describe 'some crud tests' do
    let(:dreamer) { create :dreamer, role: 'admin' }
    let(:top_dream) { create :top_dream }
    before { sign_in dreamer }

    describe '#index' do
      subject { get :index }

      it { is_expected.to be_success }
    end

    describe '#show' do
      subject { get :show, id: top_dream.id }

      it { is_expected.to be_success }
    end

    describe '#create' do
      before { post :create, top_dream: { title: 'new title', description: 'desciption' } }

      it { expect(response).to be_success }
      it { expect(TopDream.count).to eq(1) }
    end

    describe '#update' do
      subject { patch :update, id: top_dream.id, top_dream: { title: 'new title' } }

      it { is_expected.to be_success }
    end

    describe '#delete' do
      before { delete :destroy, id: top_dream.id }

      it { expect(response).to redirect_to(action: :index) }
      it { expect(TopDream.count).to eq(0) }
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
