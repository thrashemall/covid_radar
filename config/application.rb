require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
# require 'active_job/railtie'
require 'active_record/railtie'
# require 'active_storage/engine'
require 'action_controller/railtie'
# require 'action_mailer/railtie'
# require 'action_mailbox/engine'
# require 'action_text/engine'
require 'action_view/railtie'
# require 'action_cable/engine'
# require 'sprockets/railtie'
# require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CovidRadar
  class Application < Rails::Application
    config.load_defaults 6.0
    config.time_zone = 'UTC'
    config.active_record.default_timezone = :utc
    config.action_controller.include_all_helpers = false
    config.active_record.schema_format = :sql
    config.api_only = true
  end
end
