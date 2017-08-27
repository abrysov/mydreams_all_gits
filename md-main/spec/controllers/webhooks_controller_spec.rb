require 'rails_helper'

RSpec.describe MailgunWebhooksController, type: :controller do
  describe 'With mailgun json params' do
    let(:params) do
      json = JSON.parse(File.read(Rails.root.join('spec/fixtures/mailgun_webhook_hash.json')))
      json['signature'] = signature(json['timestamp'], json['token'])
      json
    end

    describe 'POST complained' do
      subject { post :complain, params }
      it { is_expected.to be_success }
    end

    describe 'POST unsubscribed' do
      subject { post :unsubscribe, params }
      it { is_expected.to be_success }
    end

    describe 'POST bounced' do
      subject { post :bounce, params }
      it { is_expected.to be_success }
    end
  end

  def signature(timestamp, token)
    digest = OpenSSL::Digest::SHA256.new
    data = [timestamp, token].join
    OpenSSL::HMAC.hexdigest(digest, Dreams.config.mail.api_key, data)
  end
end
