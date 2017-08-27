require 'rails_helper'

RSpec.describe Relations::Follow do
  let(:dreamer) { FactoryGirl.create :light_dreamer }
  subject { described_class.call dreamer, another_dreamer }

  describe '.call' do
    context 'when invalid dreamers' do
      let(:another_dreamer) { dreamer }
      let(:error_message) { I18n.t('relations.errors.invalid_dreamer') }

      it { is_expected.not_to be_success }
      it { is_expected.to have_status_error error_message }
      it { expect { subject }.not_to change { dreamer.followees.count } }
    end

    context 'when have already subscribed' do
      let(:another_dreamer) { FactoryGirl.create :light_dreamer }
      let(:error_message) { I18n.t('relations.errors.subscribed_already') }
      before { dreamer.followees << another_dreamer }

      it { is_expected.not_to be_success }
      it { is_expected.to have_status_error error_message }
      it { expect { subject }.not_to change { dreamer.followees.count } }
    end

    context 'successful' do
      let(:another_dreamer) { FactoryGirl.create :light_dreamer }

      it { is_expected.to be_success }
      it { expect { subject }.to change { dreamer.followees.count }.by(1) }
      it { expect { subject }.to change { another_dreamer.followers.count }.by(1) }
      it { expect { subject }.to change { another_dreamer.subscribers.count }.by(1) }
    end
  end
end
