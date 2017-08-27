require 'rails_helper'

RSpec.describe Purchasing::Process do
  let(:dreamer) { create :light_dreamer }
  let(:destination) { create :light_dreamer }
  let(:dream) { create :dream, dreamer: dreamer }
  let(:account) { create :account, dreamer: dreamer }
  let(:product) { create :product, name: 'certificate', product_type: 'cert' }

  describe 'buy certificate' do
    context 'true way' do
      let(:purchase) do
        create :purchase, dreamer: dreamer, product: product, destination_dreamer: destination,
                          destination: dream, comment: account.amount
      end
      let(:processing) { described_class.call(purchase) }

      before { processing }

      it { expect(processing.success?).to eq true }
      it { expect(processing.data.class.name).to eq 'Transaction' }
      it do
        dreamer.reload
        expect(dreamer.account.amount).to eq account.amount - product.cost
      end
      it do
        result = processing.data
        expect(processing.data).to eq Transaction.last
        expect(result.reason.purchase).to eq purchase
        expect(result.reason.purchase.destination_dreamer).to eq destination
        expect(result.reason.purchase.destination).to eq dream
        expect(result.complete?).to eq true
        expect(result.reason.complete?).to eq true
        expect(purchase.complete?).to eq true
      end
      it do
        dreamer.reload
        result = processing.data
        expect(result.account).to eq dreamer.account
        expect(result.after).to eq dreamer.account.amount
      end
    end
  end
end
