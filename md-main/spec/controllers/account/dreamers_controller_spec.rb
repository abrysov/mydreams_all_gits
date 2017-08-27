require 'rails_helper'

RSpec.describe Account::DreamersController do
  describe 'For signed in user' do
    before do
      sign_in dreamer
    end
    let(:dreamer) { create :dreamer }
    let(:avatar_base_64) do
      file = File.open('spec/fixtures/avatar.jpg', 'rb').read
      "data:image/jpeg;base64,#{Base64.encode64(file)}"
    end

    describe 'PATCH #upload_crop_avatar' do
      let(:avatar_params) do
        {
          avatar: avatar_base_64,
          avatar_crop_x: 100,
          avatar_crop_y: 100,
          avatar_crop_h: 230,
          avatar_crop_w: 230
        }
      end

      before do
        post :upload_crop_avatar, avatar_params.merge(id: dreamer.id)
      end

      it { expect(response).to be_success }
      it do
        dreamer.reload
        json = JSON.parse(response.body)
        expect(json['avatar_url']).to be_eql dreamer.avatar.url(:medium)
      end
      it { expect(dreamer.reload.read_attribute(:avatar)).not_to be_nil }
      it { expect(dreamer.reload.avatar.url).not_to be_nil }
    end

    describe 'PATCH #upload_crop_dreambook_bg' do
      let(:dreambook_bg_params) do
        {
          dreambook_bg: avatar_base_64,
          dreambook_bg_crop_x: 100,
          dreambook_bg_crop_y: 100,
          dreambook_bg_crop_h: 230,
          dreambook_bg_crop_w: 230
        }
      end

      before do
        post :upload_crop_dreambook_bg, dreambook_bg_params.merge(id: dreamer.id)
      end

      it { expect(response).to be_success }
      it do
        dreamer.reload
        json = JSON.parse(response.body)
        expect(json['dreambook_bg_url']).to be_eql dreamer.dreambook_bg.url(:cropped)
      end
      it { expect(dreamer.reload.dreambook_bg.url).not_to be_nil }
      it { expect(dreamer.reload.read_attribute(:dreambook_bg)).not_to be_nil }
    end

    describe 'PATCH #upload_page_bg' do
      before do
        post :update_page_bg, id: dreamer.id,
                              page_bg: fixture_file_upload('avatar.jpg', 'image/jpg')
      end

      it { expect(response).to be_redirect }
      it 'page_bg' do
        expect(dreamer.reload.read_attribute(:page_bg)).not_to be_nil
      end
    end

    describe 'when dreamer delete itself' do
      let(:friend_dreamer) { create :light_dreamer }
      let(:not_friend_dreamer) { create :light_dreamer }
      before do
        Relations::SendFriendRequest.call from: friend_dreamer, to: dreamer
        get :remove_profile, id: dreamer.id
      end

      it { expect(response).to be_redirect }
      it { expect(Dreamer.find(dreamer.id)).to be_deleted }
      it 'create Activity' do
        expect(Activity.where(owner: dreamer.id, key: 'dreamer_deleted')).to exist
      end

      describe 'Notifications' do
        let(:friend_notification) { Notification.where(dreamer_id: friend_dreamer.id) }
        let(:not_friend_notification) { Notification.where(dreamer_id: not_friend_dreamer.id) }

        it 'not create for not friend dreamer' do
          expect(not_friend_notification).not_to exist
        end
        it 'create for friend with dreamer_deleted key' do
          expect(friend_notification).to exist
          expect(friend_notification.first.action).to eq 'dreamer_deleted'
        end
      end
    end
  end
end
