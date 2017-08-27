require 'rails_helper'

RSpec.describe Dream do
  describe 'relations' do
    it { is_expected.to belong_to(:summary_certificate_type).class_name(CertificateType) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :description }
  end
end
