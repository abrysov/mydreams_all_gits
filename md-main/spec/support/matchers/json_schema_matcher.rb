require 'rspec/expectations'

RSpec::Matchers.define :be_validated_by_schema do |schema_name|
  match do |response|
    schema_name = controller.controller_path.tr('/', '_') if controller && schema_name.nil?
    schema = File.join(ActionController::TestCase.fixture_path, "schema/#{schema_name}.json")
    json = response.respond_to?(:body) ? response.body : response
    JSON::Validator.validate!(schema, json, strict: true)
  end
end
