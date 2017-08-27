require 'rails_helper'

RSpec.describe Purchasing::Transaction do
  let(:dreamer) { create :light_dreamer }
  let(:account) { create :account, dreamer: dreamer, amount: 1234 }
  let(:destination) { create :light_dreamer }

  describe 'true way' do
    context 'create transactions' do
      let(:dream) { create :dream, dreamer: destination }
      let(:product) { create :gold_certificate }
      let(:purchase) do
        create :purchase, dreamer: account.dreamer, destination: dream, product: product,
                          comment: account.amount
      end
      let(:transaction) { described_class.call(purchase: purchase, operation: :buy) }

      before { transaction }

      it { expect(transaction.success?).to eq true }
      it { expect(dreamer.account.amount).to eq 1234 }
      it do
        result = transaction.data
        expect(result.class.name).to eq 'Transaction'
        expect(result.reason.class.name).to eq 'PurchaseTransaction'
      end
      it do
        result = transaction.data
        expect(transaction.data).to eq Transaction.last
        expect(result.complete?).not_to eq true
        expect(result.reason.complete?).not_to eq true
        expect(purchase.complete?).not_to eq true
      end
      it do
        result = transaction.data
        expect(result.account).to eq dreamer.account
        expect(result.before).to eq dreamer.account.amount
        expect(result.after).to eq dreamer.account.amount - product.cost
      end
    end

    context 'create refill' do
      let(:product) { create :product_vip }
      let(:purchase) do
        create :purchase, dreamer: account.dreamer, destination: destination, product: product,
                          comment: account.amount
      end
      let(:transaction) { described_class.call(purchase: purchase, operation: :buy) }

      before { transaction }

      it { expect(transaction.success?).to eq true }
      it { expect(dreamer.account.amount).to eq 1234 }
      it do
        result = transaction.data
        expect(result.class.name).to eq 'Transaction'
        expect(result.reason.class.name).to eq 'PurchaseTransaction'
      end
      it do
        result = transaction.data
        expect(transaction.data).to eq Transaction.last
        expect(result.complete?).not_to eq true
        expect(result.reason.complete?).not_to eq true
        expect(purchase.complete?).not_to eq true
      end
      it do
        result = transaction.data
        expect(result.account).to eq dreamer.account
        expect(result.before).to eq dreamer.account.amount
        expect(result.after).to eq dreamer.account.amount - product.cost
      end
    end
  end
end
