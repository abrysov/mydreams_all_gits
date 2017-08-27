require 'rails_helper'

RSpec.describe YandexkassaController, type: :controller do
  let(:dreamer) { create :dreamer, id: 100_500 }
  let(:certificate) { create :certificate }
  let(:invoice) do
    create :invoice, :self_vip_type, id: 123, amount: 100, dreamer: dreamer,
                                     redirect_path: '/success', payable: certificate
  end
  let(:shop_id) { Dreams.config.secret.payments.yandex_kassa.shopId }
  let(:scid) { Dreams.config.secret.payments.yandex_kassa.scid }
  let(:amount) { format('%.2f', invoice.amount) }
  let(:params) do
    {
      'orderNumber' => invoice.id,
      'orderSumAmount' => amount,
      'paymentType' => 'AC',
      'requestDatetime' => '2016-04-05T17:21:09.192+03:00',
      'orderCreatedDatetime' => '2016-04-05T17:21:09.062+03:00',
      'shopId' => shop_id,
      'scid' => scid,
      'orderSumBankPaycash' => '1003',
      'orderSumCurrencyPaycash' => '10643',
      'customerNumber' => dreamer.id,
      'invoiceId' => '2000000742334',
      'md5' => '7994EB4D3D8243B3D026333A70EEC7C6'
    }
  end

  describe 'POST #check' do
    context 'when success check order' do
      subject { post :check, params }

      it { is_expected.to be_success }
      it { expect(subject.body).to include('checkOrderResponse') }
      it { expect(subject.body).to include('performedDatetime') }
      it { expect(subject.body).to include('code="0"') }
      it { expect(subject.body).to include("invoiceId=\"#{params['invoiceId']}\"") }
      it { expect(subject.body).to include("shopId=\"#{shop_id}\"") }
    end

    context 'when wrong md5' do
      before { params['md5'] = 'wrong' }
      subject { post :check, params }

      it { is_expected.to be_success }
      it { expect(subject.body).to include('checkOrderResponse') }
      it { expect(subject.body).to include('performedDatetime') }
      it { expect(subject.body).to include('code="1"') }
      it { expect(subject.body).to include("invoiceId=\"#{params['invoiceId']}\"") }
      it { expect(subject.body).to include("shopId=\"#{shop_id}\"") }
    end
  end

  describe 'POST #aviso' do
    let(:params_aviso) do
      clone_params = params
      clone_params['md5'] = 'E35316611B5221830DC4C81811E09FAA'
      clone_params
    end

    describe 'when success payment aviso' do
      before do
        Relations::SendFriendRequest.call from: subscribed_dreamer, to: dreamer
        post :aviso, params_aviso
      end
      subject { response.body }
      let(:find_activity) { Activity.where(owner_id: dreamer.id) }
      let(:subscribed_dreamer) { create :light_dreamer }
      let(:notsubscribed_dreamer) { create :light_dreamer }
      let(:subscribed_notification) { Notification.where(dreamer_id: subscribed_dreamer.id) }
      let(:not_subscr_notification) { Notification.where(dreamer_id: notsubscribed_dreamer.id) }
      let(:certificate) { create :certificate }
      let(:invoice_params) do
        { id: 123, amount: 100, dreamer: dreamer,
          redirect_path: '/success', payable: certificate }
      end

      it { expect(response).to be_success }
      it { is_expected.to include('paymentAvisoResponse') }
      it { is_expected.to include('performedDatetime') }
      it { is_expected.to include('code="0"') }
      it { is_expected.to include("invoiceId=\"#{params['invoiceId']}\"") }
      it { is_expected.to include("shopId=\"#{shop_id}\"") }
      it { expect(Invoice.find(invoice.id).state).to eq 'success' }

      describe 'when vip' do
        context 'when paid self vip' do
          let(:invoice) do
            create :invoice, :self_vip_type, invoice_params
          end
          let(:certificate) { create :certificate }

          it { expect(Dreamer.find(dreamer.id)).to be_is_vip }
          it 'create Activity with key paid_self_vip' do
            expect(find_activity.where(key: 'paid_self_vip')).to exist
          end
          context 'Notifications' do
            it 'not create for not subscribed dreamer' do
              expect(not_subscr_notification).not_to exist
            end
            it 'create for subscribed with paid_self_vip key' do
              expect(subscribed_notification).to exist
              expect(subscribed_notification.first.action).to eq 'paid_self_vip'
            end
          end
        end

        context 'when paid gift vip' do
          let(:invoice) do
            create :invoice, :gift_vip_type, invoice_params
          end
          let(:certificate) { create :certificate, gifted_by: dreamer }

          it { expect(Dreamer.find(certificate.gifted_by.id)).to be_is_vip }
          it 'create Activity with key paid_gift_vip' do
            expect(find_activity.where(key: 'paid_gift_vip')).to exist
          end
          context 'Notifications' do
            it 'not create for not subscribed dreamer' do
              expect(not_subscr_notification).not_to exist
            end
            it 'create for subscribed with paid_gift_vip key' do
              expect(subscribed_notification).to exist
              expect(subscribed_notification.first.action).to eq 'paid_gift_vip'
            end
          end
        end
      end

      describe 'when certificate' do
        let(:invoice) { create :invoice, :for_certificate, invoice_params }

        context 'when paid self' do
          let(:certificate) { create :certificate }

          it { expect(Certificate.find(certificate.id).paid).to be true }
          it 'create Activity with key paid_self_certificate' do
            expect(find_activity.where(key: 'paid_self_certificate')).to exist
          end
          context 'Notifications' do
            it 'not create for not subscribed dreamer' do
              expect(not_subscr_notification).not_to exist
            end
            it 'create for subscribed with paid_self_certificate key' do
              expect(subscribed_notification).to exist
              expect(subscribed_notification.first.action).to eq 'paid_self_certificate'
            end
          end
        end

        context 'when paid gift' do
          let(:certificate) { create :certificate, gifted_by: dreamer }

          it { expect(Certificate.find(certificate.id).paid).to be true }
          it 'create Activity with key paid_gift_certificate' do
            expect(find_activity.where(key: 'paid_gift_certificate')).to exist
          end
          context 'Notifications' do
            it 'not create for not subscribed dreamer' do
              expect(not_subscr_notification).not_to exist
            end
            it 'create for subscribed with paid_gift_certificate key' do
              expect(subscribed_notification).to exist
              expect(subscribed_notification.first.action).to eq 'paid_gift_certificate'
            end
          end
        end
      end
    end
  end

  describe 'GET #success' do
    context 'when success' do
      before { get :success, params }
      subject { response }

      it { is_expected.to redirect_to invoice.redirect_path }
    end

    context 'when wrong invoice' do
      before do
        params['orderNumber'] = '999'
        get :success, params
      end
      subject { response }

      it { is_expected.to redirect_to root_url }
    end

    context 'when without orderNumber' do
      before do
        params.delete('orderNumber')
        get :success, params
      end
      subject { response }

      it { is_expected.to redirect_to root_url }
    end
  end

  describe 'GET #failed' do
    context 'when find invoice' do
      before { get :failed, params }

      it { expect(response).to redirect_to invoice.redirect_path }
      it { expect(Invoice.find(invoice.id).state).to eq 'fail' }
    end

    context 'when not find invoice' do
      before do
        params.delete('orderNumber')
        get :failed, params
      end

      it { expect(response).to redirect_to root_url }
    end
  end
end
