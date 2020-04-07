# frozen_string_literal: true

module BugTracker
  def self.notify_message(message, options = {})
    Raven.capture_message(message, extra: options)
  end

  def self.notify_exception(exception, options: {}, logger: Rails.logger)
    logger.error("#{exception}\n#{Array(exception.backtrace).join}")
    Raven.capture_exception(exception, extra: options)
  end
end
