# frozen_string_literal: true

require 'sidekiq/middleware/i18n'

Sidekiq.default_worker_options = { 'backtrace' => true }
# Sidekiq::Extensions.enable_delay!

Sidekiq.configure_server do |config|
  config.redis = { url: Rails.application.secrets.redis_sidekiq_url! }
  config.average_scheduled_poll_interval = 5

  config.on(:startup) do
    Sidekiq.schedule = YAML.load_file(Rails.root.join('config', 'sidekiq_scheduler.yml'))
    SidekiqScheduler::Scheduler.instance.reload_schedule!
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: Rails.application.secrets.redis_sidekiq_url! }
  config.logger.level = Logger::WARN
end
