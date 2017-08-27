require 'rails_helper'

RSpec.describe Purchasing::Create do
  let(:dreamer) { create :light_dreamer }
  let(:product) { create :product }

  describe 'purchase' do
    context 'factory' do
      let(:purchase) { create :purchase }
      before { purchase }

      it { expect(purchase).to eq Purchase.last }
    end

    context 'created' do
      let(:purchase) do
        described_class.call(dreamer: dreamer, destination: dreamer, product: product,
                             comment: 'hello')
      end

      before { purchase }

      it { expect(purchase.data).to eq Purchase.last }
      it { expect(purchase.success?).to eq true }
    end

    context 'product locked' do
      let(:locked) { create :product, :locked }
      let(:purchase) do
        described_class.call(dreamer: dreamer, destination: dreamer, product: locked)
      end

      it { expect { purchase }.to raise_error(ArgumentError) }
    end
  end
end
