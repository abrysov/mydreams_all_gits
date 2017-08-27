require 'rails_helper'

RSpec.describe Account::PostsController do
  describe 'Account::PostsController#create' do
    let(:post_params) { attributes_for :post }
    before do
      sign_in create(:dreamer)
      post :create, post: post_params
    end

    it { expect(response).to be_redirect }
    it { expect(Post.where(title: post_params[:title])).to exist }
    it { expect(Post.last.photo.url).not_to be_nil }
    it { expect(Post.last.read_attribute(:photo)).not_to be_nil }
  end

  describe 'GET #index' do
    describe 'without posts' do
      let(:dreamer) { create :light_dreamer }
      subject { get :index, dreamer_id: dreamer.id }

      it { is_expected.to be_success }
    end

    describe 'with posts' do
      let(:dreamer) { create :light_dreamer }
      before { create(:post, dreamer: dreamer) }
      subject { get :index, dreamer_id: dreamer.id }

      it { is_expected.to be_success }
    end
  end
end
