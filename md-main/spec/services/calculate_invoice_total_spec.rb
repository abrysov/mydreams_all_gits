require 'rails_helper'

RSpec.describe CalculateInvoiceTotal do
  before { setup_settings }
  context 'by standart dreamer' do
    subject { described_class.call invoice }

    context 'when VIP status' do
      let(:invoice) { create :invoice, :self_vip_type }

      it { is_expected.to eq Setting.vip_status_price }
    end

    context 'when certificate' do
      let(:certificate) { create :certificate }
      let(:invoice) { create :invoice, :for_certificate, payable: certificate }
      let(:total) { Setting.certificate_price * certificate.certificate_type.value }

      it { is_expected.to eq total }
    end
  end

  context 'by super dreamer' do
    let(:project_dreamer) { create :dreamer, :project_dreamer }
    subject { described_class.call(invoice, current_dreamer: project_dreamer) }

    context 'when VIP status' do
      let(:invoice) { create :invoice, :self_vip_type }

      it { is_expected.to eq 1 }
    end

    context 'when certificate' do
      let(:certificate) { create :certificate }
      let(:invoice) { create :invoice, :for_certificate, payable: certificate }

      it { is_expected.to eq 1 }
    end
  end
end
