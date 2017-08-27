require 'rails_helper'

RSpec.describe Account::CertificatesController do
  describe 'get #index' do
    let(:params) { {} }
    before { sign_in dreamer }
    subject { get :index, params }

    context 'with no new certificates' do
      let(:certificate) { create :certificate }
      let(:dreamer) { certificate.certifiable.dreamer }

      it { is_expected.to be_success }
    end

    context 'with new certificate' do
      let(:certificate) { create :certificate }
      let(:dreamer) { certificate.certifiable.dreamer }
      let(:params) { { new_certificate: Base64.strict_encode64(certificate.id.to_s) } }

      it { is_expected.to be_success }
    end
  end
end
