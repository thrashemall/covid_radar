class AboutAnswer < ApplicationInteraction
  def reply(api)
    api.send_message(chat_id: message_chat.id, text: text)
  end

  private

  def text
    <<~DOC
      Data is provided by Johns Hopkins CSSE https://systems.jhu.edu/research/public-health/ncov/

      We update dataset every 15 minutes.

      For any wishes or suggestions, please write to covidradar@yahoo.com

      Please stay home, love loved ones and be healthy.
    DOC
  end
end
