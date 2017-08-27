require 'rails_helper'

RSpec.describe Payment::Gateway do
  let(:dreamer) { create :light_dreamer }
  let(:product) { create :special_rate }

  describe 'Create payment' do
    context 'create external transactions' do
      let(:result) do
        described_class.new(:robokassa).create_transactions dreamer, 100
      end

      before do
        product
        result
      end

      it { expect(result.success?).to eq true }
      it { expect(result.data).to eq Transaction.last }
      it { expect(result.data.reason).to eq ExternalTransaction.last }
    end

    context 'redirect to robokassa' do
      let(:result) do
        described_class.new(:robokassa).create_payment dreamer: dreamer, amount: 100,
                                                       description: 'test'
      end

      before do
        product
        result
      end

      it { expect(result.success?).to eq true }
      it 'redirects to correct url' do
        payment_url = Rubykassa.pay_url(ExternalTransaction.last.invoice.id, 100,
                                        description: 'test')
        result.data == payment_url
      end
    end

    context 'unknown gateway' do
      let(:result) do
        described_class.new(:qiwiishop).create_payment dreamer: dreamer, amount: 100,
                                                       description: 'test'
      end

      it { expect { result }.to raise_error(ArgumentError) }
    end
  end
end
