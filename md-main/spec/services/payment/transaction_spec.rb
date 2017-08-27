require 'rails_helper'

RSpec.describe Payment::Transaction do
  let(:dreamer) { create :light_dreamer }

  describe 'true way' do
    context 'create transactions' do
      let(:transaction) do
        described_class.call(dreamer: dreamer, amount: 11, gateway: :robokassa)
      end

      before { transaction }

      it { expect(transaction.success?).to eq true }
      it { expect(dreamer.account.amount).to eq 0 }
      it 'relations' do
        result = transaction.data
        expect(result.class.name).to eq 'Transaction'
        expect(result.reason.class.name).to eq 'ExternalTransaction'
        expect(result.reason.invoice.class.name).to eq 'Invoice'
      end
      it 'account transaction' do
        result = transaction.data
        expect(transaction.data).to eq Transaction.last
        expect(result.complete?).not_to eq true
        expect(result.reason.complete?).not_to eq true
      end
      it 'balance before & after' do
        result = transaction.data
        expect(result.account).to eq dreamer.account
        expect(result.before).to eq dreamer.account.amount
        expect(result.after).to eq 11
      end
      it 'isset Invoice' do
        result = transaction.data.reason.invoice
        expect(result.dreamer).to eq dreamer
        expect(result.amount).to eq 11
      end
    end
  end
end
