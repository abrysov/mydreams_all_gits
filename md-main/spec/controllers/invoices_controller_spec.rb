require 'rails_helper'

RSpec.describe InvoicesController do
  describe 'by standart dreamer' do
    let(:dreamer) { create :dreamer, role: :admin }
    before do
      sign_in dreamer
      setup_settings
    end

    describe 'POST buy_vip' do
      before { post :buy_vip }

      it 'creates invoice with correct dreamer' do
        invoice = assigns(:invoice)
        expect(invoice.dreamer).to eq dreamer
      end

      it 'creates invoice with correct type' do
        invoice = assigns(:invoice)
        expect(invoice).to be_vip
      end

      it { expect(response).to redirect_to '/test' }
    end

    describe 'POST gift_vip' do
      let(:receiver) { create :dreamer }
      let(:invoice) { assigns(:invoice) }
      before { post :gift_vip, dreamer_id: receiver.id }

      it 'creates invoice with correct dreamer' do
        expect(invoice.dreamer).to eq receiver
      end

      it 'creates invoice with correct type' do
        expect(invoice).to be_vip_gift
      end

      it { expect(response).to redirect_to '/test' }
    end

    describe 'GET certificate_self' do
      let(:certificate) { create :certificate }
      let(:params) { { payable_type: 'Certificate', payable_id: certificate.id } }
      before { get :certificate_self, params }

      it 'creates invoice with correct dreamer' do
        invoice = assigns(:invoice)
        expect(invoice.dreamer).to eq dreamer
      end

      it 'creates invoice with correct type' do
        invoice = assigns(:invoice)
        expect(invoice).to be_certificate
      end

      it { expect(response).to redirect_to '/test' }
    end
  end

  describe 'by project dreamer' do
    let(:project_dreamer) { create :dreamer, :project_dreamer }

    before do
      sign_in project_dreamer
      setup_settings
    end

    describe 'POST gift_vip by project dreamer' do
      let(:receiver) { create :dreamer }
      let(:invoice) { assigns(:invoice) }
      let(:expected_redirect_path) { '/123' }

      before { post :gift_vip, dreamer_id: receiver.id, redirect_path: expected_redirect_path }

      it 'creates invoice with correct dreamer' do
        expect(invoice.dreamer).to eq receiver
      end

      it 'creates invoice with correct type' do
        expect(invoice).to be_vip_gift
      end

      it 'creates invoice with correct amount' do
        expect(invoice.total).to eq 1
      end

      it 'creates invoice with success state' do
        expect(invoice.success?).to eq true
      end

      it 'redirects to invoice path' do
        expect(response).to redirect_to expected_redirect_path
      end
    end

    describe 'GET certificate_self' do
      let(:certificate) { create :certificate }
      let(:expected_redirect_path) { '/certificates?new_certificate' }
      let(:params) do
        { payable_type: 'Certificate',
          payable_id: certificate.id,
          redirect_path: expected_redirect_path }
      end
      let(:invoice) { assigns(:invoice) }
      before { get :certificate_self, params }

      it 'creates invoice with correct dreamer' do
        expect(invoice.dreamer).to eq project_dreamer
      end

      it 'creates invoice with correct type' do
        expect(invoice).to be_certificate
      end

      it 'creates invoice with correct amount' do
        expect(invoice.total).to eq 1
      end

      it 'makes associate certificate paid' do
        expect(invoice.payable.paid).to eq true
      end

      it 'creates invoice with success state' do
        expect(invoice.success?).to eq true
      end

      it 'redirects to right path' do
        expect(response).to redirect_to expected_redirect_path
      end
    end
  end
end
