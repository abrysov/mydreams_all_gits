require 'rails_helper'

RSpec.describe Api::V1::BannersController, type: :controller do
  let(:dreamer) { create(:light_dreamer) }
  let(:token) { Doorkeeper::AccessToken.create!(resource_owner_id: dreamer.id).token }
  let(:json_response) { JSON.parse(response.body) }
  let(:schema) { "#{fixture_path}/schema/v1_banner.json" }
  let(:ad_page) { create :ad_page, :with_banner }
  let(:banner) { ad_page.banners.relevant.first }
  let(:route) { ad_page.route }
  subject { get :show, access_token: token, route: route }

  describe 'GET #show' do
    context 'get banner by valid route' do
      it do
        subject
        expect(JSON::Validator.validate!(schema, response.body)).to be true
      end
      it do
        subject
        expect(json_response['meta']['code']).to eq 200
        expect(json_response['meta']['status']).to eq 'success'
      end
      it 'has to increase show_count' do
        expect { subject }.to change { banner.reload.show_count }.by(1)
      end
    end

    describe 'when ad_page with valid and expired date' do
      let(:ad_page) { create :ad_page_with_valid_and_expired_banner }
      let(:active_banner) { ad_page.banners.active.first }
      let(:not_active_banner) { ad_page.banners.where.not(banners: { id: active_banner.id }).first }

      context '2 banners with valid and expired date' do
        it 'increase valid banner show_count' do
          expect { subject }.to change { active_banner.reload.show_count }.by(1)
        end
        it 'not increase expired banner show_count' do
          expect { subject }.to change { not_active_banner.reload.show_count }.by(0)
        end
      end

      context 'only one banner with expired date' do
        let(:ad_page) { create :ad_page, :with_expired_banner }

        it do
          subject
          expect(json_response['meta']['code']).to eq 404
          expect(json_response['meta']['status']).to eq 'fail'
        end
      end
    end

    describe 'when 2 requests for ad_page with 2 active banners' do
      context 'get relevant banner per request' do
        let(:ad_page) { create :ad_page, :with_two_banners }
        subject do
          get :show, access_token: token, route: route
          get :show, access_token: token, route: route
        end

        it 'has to increase show_count separate banners' do
          subject
          expect(ad_page.banners.count).to eq(2)
          expect(ad_page.banners.first.show_count).to eq(1)
          expect(ad_page.banners.last.show_count).to eq(1)
        end

        it 'has to increase show_count by 2 in sum' do
          expect { subject }.to change { ad_page.reload.banners.map(&:show_count).reduce(:+) }.by(2)
        end
      end
    end

    context 'get banner by invalid route' do
      before { get :show, access_token: token, route: '123' }
      it do
        expect(json_response['meta']['code']).to eq 404
        expect(json_response['meta']['status']).to eq 'fail'
      end
    end
  end
end
