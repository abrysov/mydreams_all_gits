require 'rails_helper'

RSpec.describe Transactions::Process do
  let(:account) { create :account, amount: 100 }

  describe 'internal transaction' do
    context 'buy' do
      let(:transaction) do
        create :transaction, account: account, operation: :buy, amount: 11
      end

      let(:result) { described_class.call(transaction) }
      before { result }

      it { expect(result.success?).to be true }
      it { expect(account.reload.amount).to eq 89 }
      it do
        transaction.reload
        expect(transaction.before).to eq 100
        expect(transaction.after).to eq 89
        expect(transaction.complete?).to eq true
      end
    end

    context 'refill' do
      let(:transaction) do
        create :transaction, account: account, operation: :refill, amount: 10
      end

      let(:result) { described_class.call(transaction) }
      before { result }

      it { expect(result.success?).to be true }
      it { expect(account.reload.amount).to eq 110 }
      it do
        transaction.reload
        expect(transaction.before).to eq 100
        expect(transaction.after).to eq 110
        expect(transaction.complete?).to eq true
      end
    end

    context 'not enough money' do
      let(:empty_account) { create :account, amount: 0 }
      let(:transaction) do
        create :transaction, account: empty_account, operation: :buy, amount: 110
      end
      let(:result) { described_class.call(transaction) }

      it do
        expect { result }.to raise_error do |error|
          expect(error).to be_a(NegativeAmountError)
          expect(transaction.state).to eq 'failed'
          expect(transaction.reason.state).to eq 'failed'
        end
      end
    end
  end
end
