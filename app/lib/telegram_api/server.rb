# frozen_string_literal: true

module TelegramApi
  class Server
    TIME_ROUNDING_FACTOR = 3

    delegate :logger, to: :cli
    attr_accessor :loopback_url
    attr_writer :cli

    def initialize(loopback_url: Rails.application.secrets.loopback_url!)
      @loopback_url = loopback_url
      yield(self) if block_given?
    end

    def listen
      cli.with_agent do |bot|
        bot.listen(&method(:on_message))
      end
    end

    def on_message(message)
      return if message.text.blank?

      Thread.new do
        hydra = Typhoeus::Hydra.hydra
        request = Typhoeus::Request.new(get_url(message), method: :post, body: message.as_json)
        request.on_success(&method(:on_success))
        request.on_failure(&method(:on_failure))
        hydra.queue(request)
        hydra.run
      rescue StandardError => e
        BugTracker.notify_exception(e, logger: logger)
      end
    end

    def cli
      @cli ||= Cli.new
    end

    private

    def on_failure(response)
      logger.fatal("FAILED #{response.time.round(TIME_ROUNDING_FACTOR)}sec. [#{response.code}] #{response.request.base_url}")
    end

    def on_success(response)
      logger.info("DONE #{response.time.round(TIME_ROUNDING_FACTOR)}sec. [#{response.code}]")
    end

    def get_url(message)
      if message.text.to_s.start_with?('/')
        "#{loopback_url}/bot/commands#{message.text}"
      else
        "#{loopback_url}/bot/plain"
      end
    end
  end
end
