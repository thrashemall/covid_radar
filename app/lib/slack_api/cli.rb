# frozen_string_literal: true

module SlackApi
  class Cli
    CHANNEL_USERS = '#users'

    attr_reader :webhook_url, :channel, :username

    def initialize(channel:, username: 'notifier', webhook_url: Rails.application.secrets.slack_webhook_url!)
      @webhook_url = webhook_url
      @username = username
      @channel = channel
    end

    def post(text:, icon_emoji: ':tada:')
      agent.post(text: text, icon_emoji: icon_emoji)
    end

    private

    def agent
      @agent ||= Slack::Notifier.new(webhook_url)
    end
  end
end
