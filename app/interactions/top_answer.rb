class TopAnswer < ApplicationInteraction
  LIMIT = 15

  def reply(api)
    api.send_message(chat_id: message_chat.id, text: io.string)
  end

  private

  def io
    infections.each_with_index.with_object(StringIO.new) do |(infection, index), io|
      io << <<~DOC
        #{index.next}. #{infection.country.name} / #{Formatter.number(infection.confirmed)} (#{Formatter.signed_number(infection.confirmed_rate)}%)
      DOC
    end
  end

  def infections
    Infection.where(date: date).order(confirmed: :desc).limit(LIMIT).includes(:country)
  end

  def date
    Infection.order(date: :desc).pick(:date)
  end
end
