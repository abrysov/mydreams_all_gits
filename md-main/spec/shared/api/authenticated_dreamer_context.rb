RSpec.shared_context 'authenticated dreamer' do
  let(:current_dreamer) { nil }
  before { request.env['HTTP_AUTHORIZATION'] = current_dreamer.authentication_token }
end
