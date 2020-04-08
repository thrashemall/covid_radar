class AboutAnswer < ApplicationInteraction
  def reply(api)
    api.send_message(chat_id: message_chat.id, text: text)
  end

  private

  def text
    <<~DOC
      Data is provided by Johns Hopkins CSSE https://systems.jhu.edu/research/public-health/ncov/
      We update dataset every 15 minutes.

      The program source code is open under the MIT license. 
      You may contribute here https://github.com/Covid-Lab/covid_radar
      For any wishes or suggestions, please write to covidradar@yahoo.com

      Stay home. Stay safe. Save lives.
    DOC
  end
end
