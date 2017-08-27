require 'rails_helper'

RSpec.describe Payment::Gateways::AppStore do
  let(:dreamer) { create :light_dreamer }
  let(:receipt_data) { File.open("#{fixture_path}/appstore_receipt.txt", 'rb').read }
  let(:receipt_response) { File.open("#{fixture_path}/appstore_result.json", 'rb').read }
  let(:product) { create :inapp_appstore }

  describe 'Unknown application' do
    subject do
      gateway = described_class.new(receipt_data, product: product, bundle_id: 'not.dreams.app')

      gateway.validating_receipt_with_appstore
    end

    it 'example receipt' do
      expect { subject }.to raise_error(ArgumentError, 'Unknown application club.mydreams.MyDreams')
    end
  end

  describe 'transaction' do
    before do
      transaction = Payment::Transaction.call(dreamer: dreamer, amount: 1000, gateway: :appstore)
      external_transaction = transaction.data.reason
      external_transaction.external_transaction_id = '1000000218147651'
      external_transaction.save
    end

    subject do
      gateway = described_class.new(receipt_data, product: product)

      gateway.validate_response JSON.parse receipt_response
    end

    it { expect { subject }.to raise_error(ArgumentError, 'Double transaction') }
  end

  describe 'validate response' do
    subject do
      gateway = described_class.new(receipt_data, product: product)

      gateway.validate_response JSON.parse receipt_response
    end

    it { expect(subject.success?).to eq true }
    it { expect(subject.data['status']).to eq 0 }
  end
end
