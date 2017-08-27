require 'rails_helper'

RSpec.describe Buy::Certificates do
  let(:dreamer) { create :light_dreamer }
  let(:product) { create :gold_certificate }

  describe 'true way' do
    let(:account) { create :account, dreamer: dreamer, amount: 1000 }

    context 'for dream' do
      let(:dream) { create :dream, dreamer: dreamer }
      let(:buy_create) do
        described_class.new.create(dreamer: account.dreamer, destination: dream, product: product)
      end

      before { buy_create }

      it { expect(buy_create.success?).to eq true }
      it do
        certificate = buy_create.data.reload
        expect(certificate.certifiable).to eq dream
        expect(certificate.gifted_by).to eq dreamer
        expect(certificate.paid).to eq true
        expect(certificate.accepted).to eq true
        expect(certificate.certificate_name).to eq 'gold'
      end
      it do
        purchase = dreamer.purchases.last
        expect(purchase.dreamer).to eq dreamer
        expect(purchase.destination_dreamer).to eq dreamer
        expect(purchase.destination).to eq dream
        expect(purchase.complete?).to eq true
      end
      it do
        dream.reload
        expect(dreamer.reload.account.amount).to eq 900
        expect(dream.launches_count).to eq 10
        expect(dream.summary_certificate_type_name).to eq buy_create.data.certificate_name
      end
    end

    context 'in progress' do
      let(:dream) { create :dream }
      let(:purchase) do
        create :purchase, dreamer: account.dreamer, destination: dream, product: product
      end
      let(:buy_create) { described_class.new(purchase).processing }

      before { buy_create }

      it { expect(buy_create.success?).to eq true }
      it do
        certificate = buy_create.data.reload
        expect(certificate.certifiable).to eq dream
        expect(certificate.gifted_by).to eq dreamer
        expect(certificate.paid).to eq true
        expect(certificate.accepted).to eq false
        expect(certificate.certificate_name).to eq 'gold'
      end
      it do
        dream.reload
        expect(dreamer.reload.account.amount).to eq 900
        expect(dream.launches_count).to eq 10
        expect(dream.summary_certificate_type_name).to eq buy_create.data.certificate_name
      end
    end

    context 'gift for dreamer' do
      let(:destination) { create :light_dreamer }
      let(:dream) { create :dream, dreamer: destination }
      let(:buy_create) do
        described_class.new.create(dreamer: account.dreamer, destination: dream,
                                   product: product, comment: 'hello')
      end

      before { buy_create }

      it { expect(buy_create.success?).to eq true }
      it { expect(dreamer.reload.account.amount).to eq 900 }
      it do
        certificate = buy_create.data.reload
        expect(certificate.wish).to eq 'hello'
        expect(certificate.certifiable).to eq dream
        expect(certificate.gifted_by).to eq dreamer
        expect(certificate.accepted).to eq false
        expect(certificate.certificate_name).to eq 'gold'
      end
    end
  end

  describe 'failed' do
    context 'not enough money' do
      let(:account) { create :account, dreamer: dreamer, amount: 90 }
      let(:dream) { create :dream, dreamer: dreamer }
      let(:buy_create) do
        described_class.new.create(dreamer: account.dreamer, destination: dream, product: product)
      end

      it { expect { buy_create }.to raise_error(NegativeAmountError) }
    end
  end
end
