class SingleCountryPicker < ApplicationInteraction
  def reply(api)
    api.send_message(chat_id: message_chat.id, text: text, reply_markup: markup)
  end

  private

  def text
    "Enter the ISO2 country code (example: #{Country::SAMPLE_CODES.sample(2).join(' or ')}) or select the country through the keyboard"
  end

  def markup
    Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: keyboard, one_time_keyboard: true)
  end

  def keyboard
    Country.order(name: :asc).pluck(:name).in_groups_of(2)
  end
end
