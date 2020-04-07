class ExceptionAnswer < ApplicationInteraction
  def reply(api)
    api.send_message(chat_id: message_chat.id, text: text)
  end

  private

  def text
    'Ooops... 😞 a server error occured. We will fix it as soon as possible'
  end
end
