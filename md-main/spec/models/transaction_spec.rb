require 'rails_helper'

RSpec.describe Transaction do
  let(:account) { create :account }

  it { is_expected.to belong_to :account }

  context 'state' do
    it { is_expected.to have_state :pending }
    it do
      is_expected.to allow_event :to_complete
      is_expected.to allow_event :to_fail
    end
  end

  context 'external transaction' do
    let(:transaction) { create :transaction, :external, account: account }

    subject { transaction }

    it { expect(subject).to be_valid }
    it do
      expect(transaction.reason).not_to be_nil
      expect(transaction.reason).to be_instance_of ExternalTransaction
    end

    it do
      transaction.reload
      expect(transaction).to have_state(:pending)
      expect(transaction.before).not_to be_nil
      expect(transaction.after).not_to be_nil
      expect(transaction.before).to eq account.amount
      expect(transaction.after).to eq account.amount + transaction.amount
    end
  end

  context 'purchase transaction' do
    let(:transaction) { create :transaction, account: account }

    subject { transaction }

    it { expect(subject).to be_valid }
    it do
      expect(transaction.reason).not_to be_nil
      expect(transaction.reason).to be_instance_of PurchaseTransaction
    end

    it do
      transaction.reload
      expect(transaction).to have_state(:pending)
      expect(transaction.before).not_to be_nil
      expect(transaction.after).not_to be_nil
      expect(transaction.before).to eq account.amount
      expect(transaction.after).to eq account.amount + transaction.amount
    end
  end
end
