require 'rails_helper'

RSpec.describe Api::V1::Profile::RestoresController, type: :controller do
  let(:json_response) { JSON.parse(subject.body) }

  describe 'POST create' do
    context 'unauthorized' do
      subject { post :create }

      it do
        expect(subject.status).to eq 401
        expect(json_response['meta']['code']).to eq 401
        expect(json_response['meta']['status']).to eq 'fail'
      end
    end

    context 'restore dreamer' do
      let(:deleted_dreamer) { create(:dreamer, :deleted_dreamer) }
      let(:doorkeeper) { Doorkeeper::AccessToken.create!(resource_owner_id: deleted_dreamer.id) }

      before do
        post :create, access_token: doorkeeper.token
      end

      it do
        json = JSON.parse(response.body)
        restored_dreamer = Dreamer.find_by(id: deleted_dreamer.id, deleted_at: nil)

        expect(restored_dreamer.first_name).to eq(deleted_dreamer.first_name)
        expect(json['meta']['code']).to eq 200
        expect(json['meta']['status']).to eq 'success'
        expect(json['meta']['message']).to eq I18n.t('flash.success.restored')
      end
    end
  end
end
