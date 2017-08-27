require File.expand_path('../boot', __FILE__)

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

require "persey"
require File.expand_path('../config', __FILE__)

module Dreams
  class Application < Rails::Application
    config.assets.initialize_on_precompile = true

    config.sass.preferred_syntax = :sass
    config.sass.line_comments = false
    config.sass.cache = false

    config.action_view.field_error_proc = Proc.new { |html_tag, instance|
      html_tag.html_safe
    }

    I18n.load_path += Dir[Rails.root.join('config', 'locales', '*.{rb,yml}').to_s]

    config.autoload_paths << Rails.root.join('app', 'queries')
    config.autoload_paths << Rails.root.join('lib')

    config.i18n.default_locale = :ru

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
    config.exceptions_app = routes
  end
end
