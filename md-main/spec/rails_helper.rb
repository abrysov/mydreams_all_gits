ENV['CODECLIMATE_REPO_TOKEN'] = '471f5762df6b6d47a36fede9622f17b0394e5130258453e872780456f8e187fb'
ENV['HONEYBADGER_ENV'] = 'test'

require 'simplecov'
# SimpleCov.minimum_coverage 50
SimpleCov.start 'rails' do
  add_filter 'app/admin'

  add_group 'Services', 'app/services'
  add_group 'Queries', 'app/queries'
end

# require 'codeclimate-test-reporter'
# CodeClimate::TestReporter.start

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?

require 'spec_helper'
require 'rspec/rails'
require 'aasm/rspec'
# require 'capybara'
# require 'capybara/rails'
# require 'capybara/email/rspec'
# require 'capybara/poltergeist'
require 'email_spec'
# Capybara.server_host = 'localhost'
# Capybara.app_host = 'http://localhost:3009'

# Capybara.default_host = 'http://localhost:3009'
# Capybara.default_wait_time = 5
# Capybara.default_driver = :chrome
# Capybara.javascript_driver = :chrome

# Capybara.javascript_driver = :selenium
# Capybara.javascript_driver = :webkit
# Capybara.javascript_driver = :poltergeist

# Capybara.register_driver :poltergeist do |app|
#   Capybara::Poltergeist::Driver.new(app, js_errors: false)
# end

# Capybara.register_driver :firefox do |app|
#   profile = Selenium::WebDriver::Firefox::Profile.new
#   Capybara::Selenium::Driver.new( app, profile: profile)
# end

# Capybara.register_driver :chrome do |app|
#   Capybara::Selenium::Driver.new(app, browser: :chrome)
# end

# Capybara.server_port = 3009
#
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }
Dir[Rails.root.join('spec/shared/**/*.rb')].each { |f| require f }
Dir[Rails.root.join('spec/features/admin/shared/*.rb')].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

# Capybara.javascript_driver = :chrome

OmniAuth.config.test_mode = true

Faker::Config.locale = :en

RSpec.configure do |config|
  #include Rack::Test::Methods
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.warnings = false

  config.mock_with :rspec do |c|
    c.syntax = [:should, :expect]
  end

  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end

  config.include(EmailSpec::Helpers)
  config.include(EmailSpec::Matchers)
  config.include FactoryGirl::Syntax::Methods
  config.include Devise::TestHelpers, type: :controller
  config.include FeatureHelpers
  config.include SettingsHelpers

  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  config.filter_run_excluding type: :feature
  config.order = :random
  config.profile_examples = 5
  config.example_status_persistence_file_path = 'spec/examples.txt'
  # NOTE: undefined method 'describe'. Fix 'describe' to 'RSpec.describe', then 'should' to 'expect'
  # config.disable_monkey_patching!

  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

  config.before :suite do
    DatabaseCleaner.clean_with :truncation
  end

  config.before :each do |test_step|
    # Capybara.current_driver    = test_step.metadata[:browser].presence || :chrome
    # Capybara.javascript_driver = test_step.metadata[:browser].presence || :chrome
    DatabaseCleaner.strategy   = test_step.metadata[:js] ? :truncation : :transaction
    DatabaseCleaner.start
  end

  config.after :each do
    # Capybara.reset_sessions! # Should it work with this suite?
    # Capybara.use_default_driver
    DatabaseCleaner.clean
  end

  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!
end
