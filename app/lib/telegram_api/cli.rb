# frozen_string_literal: true

module TelegramApi
  class Cli
    attr_reader :token, :proxy, :loopback_url

    def initialize(token: nil, proxy: nil)
      @token = token || Rails.application.secrets.tg_bot_token!
      @proxy = proxy || Rails.application.secrets.tg_proxy!
    end

    def with_agent
      Telegram::Bot::Client.run(token, url: proxy, logger: Logger.new(STDOUT)) do |bot|
        yield(bot)
      end
    end

    def logger
      @logger ||= Logger.new(STDOUT)
    end
  end
end
