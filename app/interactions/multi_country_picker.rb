class MultiCountryPicker < ApplicationInteraction
  class << self
    attr_accessor :countries
  end

  def reply(api)
    api.send_message(chat_id: message_chat.id, text: text)
  end

  private

  def text
    "Enter two country codes to compare (example #{Country::SAMPLE_CODES.sample(self.class.countries).join(' ')})"
  end
end
