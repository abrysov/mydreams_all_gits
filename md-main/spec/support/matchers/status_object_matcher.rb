require 'rspec/expectations'

RSpec::Matchers.define :have_status_data do |expected|
  match do |actual|
    actual.data == expected
  end
end

RSpec::Matchers.define :have_status_error do |expected|
  match do |actual|
    actual.error == expected
  end
end
