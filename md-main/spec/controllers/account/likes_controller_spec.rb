require 'rails_helper'

RSpec.describe Account::LikesController do
  describe 'For signed in user' do
    let(:likeable) { FactoryGirl.create(%i{dream post}.sample) }
    let(:liked_params) { { entity_type: likeable.class, entity_id: likeable.id } }
    before do
      @dreamer = create(:dreamer)
      sign_in @dreamer
    end

    describe 'GET #like' do
      subject { xhr :get, :like, liked_params }
      it { is_expected.to be_success }
      it 'create Like' do
        expect { subject }.to change { Like.count }.by(1)
      end
      it 'create Activity' do
        expect { subject }.to change { Activity.count }.by(1)
      end
      it 'create Feedback' do
        expect { subject }.to change { Feedback.count }.by(1)
      end
    end

    describe 'GET #unlike' do
      before do
        xhr :get, :like, liked_params
      end
      subject { xhr :get, :unlike, liked_params }
      it { is_expected.to be_success }
      it 'delete Like' do
        expect { subject }.to change { Like.count }.by(-1)
      end
      it 'delete Activity' do
        expect { subject }.to change { Activity.count }.by(-1)
      end
    end
  end

  describe 'when NOT sign_in' do
    let(:likeable) { FactoryGirl.create(%i{dream post}.sample) }
    let(:liked_params) { { entity_type: likeable.class, entity_id: likeable.id } }

    describe 'GET #like' do
      subject { xhr :get, :like, liked_params }
      it { is_expected.to have_http_status 401 }
    end

    describe 'GET #unlike' do
      subject { xhr :get, :unlike, liked_params }
      it { is_expected.to have_http_status 401 }
    end
  end
end
