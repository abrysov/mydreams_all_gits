require 'rails_helper'

RSpec.describe Buy::VipStatus do
  let(:dreamer) { create :light_dreamer }
  let(:account) { create :account, dreamer: dreamer, amount: 1000 }
  let(:product) { create :product_vip }

  describe 'true way' do
    context 'self' do
      let(:buy_create) do
        described_class.new.create(dreamer: account.dreamer, product: product)
      end

      before { buy_create }

      it { expect(buy_create.success?).to eq true }
      it do
        dreamer.reload
        expect(dreamer.account.amount).to eq 100
        expect(dreamer.is_vip?).to eq true
      end
      it do
        purchase = dreamer.purchases.last
        expect(purchase.dreamer).to eq dreamer
        expect(purchase.destination_dreamer).to eq dreamer
        expect(purchase.destination).to eq dreamer
        expect(purchase.complete?).to eq true
      end
    end

    context 'another dreamer' do
      let(:another) { create :light_dreamer }
      let(:buy_create) do
        described_class.new.create(dreamer: account.dreamer, product: product, destination: another)
      end

      before { buy_create }

      it { expect(buy_create.success?).to eq true }
      it do
        dreamer.reload
        another.reload

        expect(dreamer.account.amount).to eq 100
        expect(dreamer.is_vip).to eq false
        expect(another.is_vip).to eq true
      end
      it do
        purchase = dreamer.purchases.last
        expect(purchase.dreamer).to eq dreamer
        expect(purchase.destination).to eq another
        expect(purchase.destination_dreamer).to eq another
        expect(purchase.complete?).to eq true
      end
    end
  end
end
