require 'rails_helper'

RSpec.describe Buy::Coins do
  let(:dreamer) { create :light_dreamer }
  let(:product) { create :special_rate }

  context 'redirect to robokassa' do
    let(:result) do
      described_class.new(:robokassa).create dreamer: dreamer, amount: 100
    end

    before do
      product
      result
    end

    it { expect(result.success?).to eq true }
    it 'correct url' do
      payment_url = Rubykassa.pay_url(ExternalTransaction.last.id, 100, description: nil)
      result.data == payment_url
    end
  end

  context 'gift coins to another dreamer' do
    let(:source_account) { create :account }
    let(:target_account) { create :account }
    let(:coins) { create :special_rate }

    def transfer
      described_class.transfer(dreamer: source_account.dreamer,
                               destination_dreamer: target_account.dreamer,
                               product: coins,
                               quantity: 200)
    end

    it 'has - 200 to source dreamer' do
      expect { transfer }.to change { source_account.reload.amount }.by(-200)
    end

    it 'has + 200 to target dreamer' do
      expect { transfer }.to change { source_account.reload.amount }.by(-200)
    end

    it 'has 2 Transactions' do
      transfer
      expect(Transaction.where(operation: :buy, account_id: source_account.id)).to exist
      expect(Transaction.where(operation: :refill, account_id: target_account.id)).to exist
    end
  end
end
