module Bot
  class BotController < ApplicationController
    before_action :current_user
    before_action :set_raven_context

    rescue_from StandardError do |e|
      with_bot do |api|
        ExceptionAnswer.controller(self).reply(api)
        BugTracker.notify_exception(e)
      end
    end

    rescue_from Error::CountryNotFound do |e|
      with_bot do |api|
        api.send_message(chat_id: message.chat.id, text: "Country \"#{e.message}\" not found")
      end
    end

    rescue_from Error::Custom do |e|
      with_bot do |api|
        api.send_message(chat_id: message.chat.id, text: e.message)
      end
    end

    def message
      @message ||= Telegram::Bot::Types::Message.new(message_params)
    end

    def current_user
      @current_user ||= User.find_or_create_by!(uid: message.from.id, chat_id: message.chat.id) do |u|
        u.first_name = message.from.first_name
        u.last_name = message.from.last_name
        u.username = message.from.username
        u.language_code = message.from.language_code
      end
    end

    protected

    def with_bot
      TelegramApi::Cli.new.with_agent do |bot|
        yield(bot.api)
      end
    end

    private

    def set_raven_context
      Raven.user_context(id: current_user.id)
    end

    def message_params(input = params.permit!.to_h)
      input.each_with_object({}) do |(k, v), object|
        next if k == 'entities'

        object[k.to_sym] = v.is_a?(Hash) ? message_params(v) : v.presence
      end
    end
  end
end
