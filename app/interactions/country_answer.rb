class CountryAnswer < ApplicationInteraction
  def reply(api)
    api.send_message(chat_id: message_chat.id, **message_params)
  end

  def message_params
    { text: text }
  end

  private

  def text
    <<~DOC.html_safe
      #{country.name}
      #{infection.summary}
    DOC
  end

  def infection
    @infection ||= country.infections.order(date: :desc).first!
  end

  def country
    @country ||= if country_name.length == 2
      Country.by_iso2(country_name).first || raise(Error::CountryNotFound, country_name)
    else
      Country.by_name(country_name).first || raise(Error::CountryNotFound, country_name)
    end
  end

  def country_name
    @country_name ||= message_text.to_s.squish
  end
end
