require 'rails_helper'

RSpec.describe Api::V1::Purchases::CertificatesController, type: :controller do
  describe 'true way' do
    let(:token) { Doorkeeper::AccessToken.create!(resource_owner_id: account.dreamer.id).token }
    let(:schema) { "#{fixture_path}/schema/purchases/web_certificate.json" }
    let(:dreamer) { create :light_dreamer }
    let(:account) { create :account, dreamer: dreamer, amount: 1000 }
    let(:dream) { create :dream, dreamer: dreamer }
    let(:product) { create :gold_certificate }
    let(:json) { JSON.parse(response.body) }

    context 'purchase new certificate' do
      before do
        post :create, product_id: product.id, destination_id: dream.id, comment: 'hello',
                      access_token: token
      end

      it { expect(JSON::Validator.validate!(schema, response.body, strict: true)).to be true }
      it { expect(response.content_type).to eq 'application/json' }
      it do
        expect(dreamer.account.amount).to eq 900
        expect(dream.reload.launches_count).to eq 10
      end
      it do
        expect(json['certificate']).not_to be_nil
        expect(json['meta']['code']).to eq 200
        expect(json['meta']['status']).to eq 'success'
      end
      it do
        certificate = json['certificate']['certificate_type_name']
        expect(certificate).to eq dream.reload.summary_certificate_type_name.titleize
      end
      it do
        purchase = dreamer.purchases.last
        expect(purchase.dreamer).to eq dreamer
        expect(purchase.destination_dreamer).to eq dreamer
        expect(purchase.destination).to eq dream
        expect(purchase.complete?).to eq true
      end
    end

    context 'continue purchase certificate' do
      let(:purchase) { create :purchase, dreamer: dreamer, destination: dream, product: product }

      before { post :update, access_token: token, id: purchase.id }

      it { expect(JSON::Validator.validate!(schema, response.body, strict: true)).to be true }
      it { expect(dream.reload.launches_count).to eq 10 }
      it do
        expect(json['certificate']).not_to be_nil
        certificate = json['certificate']['certificate_type_name']
        expect(certificate).to eq dream.reload.summary_certificate_type_name.titleize

        expect(json['meta']['code']).to eq 200
        expect(json['meta']['status']).to eq 'success'
      end
    end

    context 'negative amount' do
      let(:schema) { "#{fixture_path}/schema/purchases/web_purchase.json" }
      let(:account) { create :account, dreamer: dreamer, amount: 10 }
      let(:purchase) do
        create :purchase, dreamer: account.dreamer, destination: dream, product: product
      end

      before { post :update, access_token: token, id: purchase.id }

      it { expect(JSON::Validator.validate!(schema, response.body, strict: true)).to be true }
      it do
        expect(json['meta']['code']).to eq 402
        expect(json['meta']['status']).to eq 'fail'
      end
    end

    context 'render bad_request' do
      let(:product) { create :gold_certificate, :locked }
      let(:purchase) do
        create :purchase, dreamer: account.dreamer, destination: dream, product: product
      end

      before { post :update, access_token: token, id: purchase.id }

      it { expect(response.status).to eq 400 }
    end

    context 'unauthorized user' do
      before { post :create }

      it { expect(response.status).to eq 401 }
      it { expect(response.content_type).to eq 'application/json' }
    end
  end
end
