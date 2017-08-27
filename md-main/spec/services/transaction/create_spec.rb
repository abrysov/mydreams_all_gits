require 'rails_helper'

RSpec.describe Transactions::Create do
  let(:account) { create :account }
  let(:dreamer) { create :light_dreamer }
  let(:reason) { create :purchase_transaction, account: account, amount: 100 }

  describe 'transaction' do
    context 'created' do
      let(:result) do
        described_class.call(account: account, operation: :buy, amount: 100, reason: reason)
      end

      it { expect(result.success?).to eq true }
      it { expect(result.data).to eq Transaction.last }
    end

    context 'invalid' do
      let(:result) do
        described_class.call(account: account, operation: :refill, amount: 0, reason: reason)
      end

      it { expect { result }.to raise_error(ValidationError) }
    end
  end
end
