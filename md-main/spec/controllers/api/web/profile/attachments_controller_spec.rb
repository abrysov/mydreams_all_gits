require 'rails_helper'

RSpec.describe Api::Web::Profile::AttachmentsController, type: :controller do
  describe 'POST create' do
    let(:dreamer) { create(:dreamer) }
    let(:file) { fixture_file_upload('norris.jpg') }

    context 'when signed in' do
      before { sign_in dreamer }

      context 'with file' do
        subject { post :create, file: file }

        it { is_expected.to be_success }
        it { is_expected.to be_validated_by_schema }
      end

      context 'with url' do
        let(:url) { 'http://blog.stanis.ru/img/93167.jpg' }

        subject { post :create, url: url }

        context 'when open url succeed' do
          before { allow(Kernel).to receive(:open).and_return(file) }

          it { is_expected.to be_success }
          it { is_expected.to be_validated_by_schema }
        end

        context 'when open url timeouts' do
          before { allow(Kernel).to receive(:open).and_raise(Net::OpenTimeout) }

          it { is_expected.to be_unprocessable }
        end
      end

      context 'without any param' do
        subject { post :create }

        it { is_expected.to be_unprocessable }
      end
    end
  end
end
