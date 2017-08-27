require 'rails_helper'

RSpec.describe Api::V1::Profile::DreambookBgsController, type: :controller do
  let(:json_response) { JSON.parse(subject.body) }

  describe 'POST create' do
    let(:token) { Doorkeeper::AccessToken.create!(resource_owner_id: dreamer.id).token }
    let(:dreambook_params) do
      {
        id: dreamer.id,
        access_token: token,
        file: fixture_file_upload('avatar.jpg', 'image/jpg'),
        crop: { x: 100, y: 100, width: 400, height: 400 }
      }
    end

    context 'create new dreambook_bg' do
      let(:dreamer) { create :light_dreamer }

      before do
        post :create, dreambook_params
        dreamer.reload
      end

      it { is_expected.to respond_with 200 }
      it do
        json = JSON.parse(response.body)

        expect(dreamer.dreambook_bg.url).to be_present
        expect(dreamer.read_attribute(:dreambook_bg)).to be_present
        expect(dreamer.crop_meta[:dreambook_bg]).to be_present
        expect(json['url']['cropped']).to eq dreamer.dreambook_bg.url(:cropped)
      end
      it do
        expect(dreamer.dreambook_bg.cropped).to be_present

        file = dreamer.dreambook_bg.cropped.file
        image = MiniMagick::Image.open(file.path)
        expect(image.width).to eq 198
        expect(image.height).to be <= 400
      end
    end

    context 'rewrite old dreambook_bg' do
      let(:dreamer) { create :dreamer, :with_dreambook_bg }

      before do
        post :create, dreambook_params
        dreamer.reload
      end

      it { is_expected.to respond_with 200 }
      it do
        expect(dreamer.dreambook_bg.url).to be_present
        expect(dreamer.read_attribute(:dreambook_bg)).to be_present
        expect(dreamer.crop_meta[:dreambook_bg]).to be_present
        expect(dreamer.dreambook_bg.file.path).to include 'avatar.jpg'
      end
    end
  end
end
