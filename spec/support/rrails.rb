RSpec.configure do |config|
  config.include ActiveSupport::Testing::TimeHelpers
  config.include Rails.application.routes.url_helpers
end
