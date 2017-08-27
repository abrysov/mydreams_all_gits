require 'rails_helper'

RSpec.describe RobokassaController do
  let(:dreamer) { create :light_dreamer }
  let(:product) { create :special_rate }
  let(:invoice) { Payment::Gateway.new('robokassa').create_transactions(dreamer, 1050).data.reason }

  describe 'POST paid' do
    let(:params_string) do
      "#{invoice.amount}:#{invoice.id}:#{ENV['ROBOKASSA_SECOND_PASSWORD']}"
    end
    let(:params) do
      {
        InvId: invoice.id,
        OutSum: invoice.amount,
        IncSum: invoice.amount,
        SignatureValue: Digest::MD5.hexdigest(params_string)
      }
    end

    before do
      product
      post :paid, params
    end

    it 'returns valid response' do
      expect(response.body).to eq "OK#{invoice.id}"
    end

    it 'marks invoice as paid' do
      payment = invoice.reload
      # expect(payment.inc_money).not_to be_nil
      # expect(payment.out_money).not_to be_nil
      # expect(payment.out_currency).to be_nil
      # expect(payment.inc_currency).to be_nil
      expect(payment.response).not_to be_nil
      expect(payment.complete?).to eq true
    end

    it 'refill amount' do
      expect(dreamer.account.amount).to eq 1050
    end
  end

  describe 'POST success' do
    let(:params_string) do
      "#{invoice.amount}:#{invoice.id}:#{ENV['ROBOKASSA_FIRST_PASSWORD']}"
    end
    let(:params) do
      {
        InvId: invoice.id,
        OutSum: invoice.amount,
        SignatureValue: Digest::MD5.hexdigest(params_string)
      }
    end

    before do
      product
      post :success, params
    end

    it 'redirects to correct_path' do
      expect(response).to redirect_to success_payment_path
    end
  end

  describe 'POST fail' do
    let(:params) { { InvId: invoice.id } }

    before do
      product
      post :fail, params
    end

    it 'marks invoice as failed' do
      payment = invoice.reload
      expect(payment.failed?).to eq true
      expect(payment.response).not_to be_nil
    end

    it 'redirects to correct path' do
      expect(response).to redirect_to fail_payment_path
    end
  end
end
