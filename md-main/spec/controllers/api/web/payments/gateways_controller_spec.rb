require 'rails_helper'

RSpec.describe Api::Web::Payments::GatewaysController, type: :controller do
  describe 'true way' do
    let(:dreamer) { create :light_dreamer }
    let(:account) { create :account, dreamer: dreamer, amount: 0 }
    let(:product) { create :special_double_rate }

    context 'purchase new certificate' do
      before do
        product
        sign_in account.dreamer

        post :create, amount: 100, gateway: 'robokassa'
      end

      it do
        expect(Transaction.count).to eq 1
        expect(ExternalTransaction.count).to eq 1
      end
      it do
        payment_url = Rubykassa.pay_url ExternalTransaction.last.invoice.id, 200,
                                        description: I18n.t('payments.description')
        expect(response).to redirect_to payment_url
      end
    end
  end
end
