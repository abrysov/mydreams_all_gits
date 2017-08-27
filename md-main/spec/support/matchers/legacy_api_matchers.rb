require 'rspec/expectations'

RSpec::Matchers.define :be_success_legacy_api_response do
  include MatchersHelpers

  # TODO: validate JSON schema instead
  match do
    [:code, :body].all? { |field| parsed_response.key? field } &&
      parsed_response[:code] == 0
  end

  failure_message do
    "expected #{parsed_response} to include :code with value 0 and :body"
  end
end

RSpec::Matchers.define :be_failed_legacy_api_response do
  include MatchersHelpers

  # TODO: validate JSON schema instead
  match do
    [:code, :message].all? { |field| parsed_response.key? field } &&
      parsed_response[:code] == 1
  end

  failure_message do
    "expected #{parsed_response} to include :code with value 1 and :body"
  end
end
