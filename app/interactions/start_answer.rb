class StartAnswer < ApplicationInteraction
  def reply(api)
    api.send_message(chat_id: message_chat.id, text: text)
  end

  private

  def text
    <<~DOC
      You can control me by sending these commands:

      /country today stats
      /chart epidemic curve
      /compare trends by two countries
      /top countries where COVID-19 has spread
      /about the bot
    DOC
  end
end
