require 'rails_helper'

RSpec.describe AwayController do
  describe '#away increase banner`s cross_count and be redirected' do
    let(:banner) { create :banner }
    let(:hash) { BannerSerializer.new(banner).attributes[:link_hash] }
    subject { get :away, link_hash: hash }

    it { is_expected { subject }.to be_redirect }
    it { is_expected { subject }.to redirect_to banner.link }
    it { expect { subject }.to change { banner.reload.cross_count }.by(1) }

    context 'when invalid link_hash' do
      subject { get :away, link_hash: '123' }
      it { is_expected { subject }.to redirect_to root_path }
    end
  end
end
