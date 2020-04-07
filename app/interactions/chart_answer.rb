class ChartAnswer < ApplicationInteraction
  LIMIT = 10

  def reply(api)
    api.send_photo(chat_id: message_chat.id, photo: Faraday::UploadIO.new(StringIO.new(chart), 'image/png'))
  end

  private

  def chart
    g = Gruff::Line.new(1600)
    g.font = Rails.root.join('vendor', 'fonts', 'HelveticaMedium.ttf').to_s
    g.title = country.name
    g.labels = labels
    g.data :Confirmed, data(:confirmed)
    g.data :Recovered, data(:recovered)
    g.data :Deaths, data(:deaths)
    g.to_blob('PNG')
  end

  def infections
    @infections ||= country.infections.order(date: :desc).limit(LIMIT).reverse
  end

  def data(status)
    infections.map(&:"#{status}")
  end

  def labels
    infections.map(&:date).each_with_index.with_object({}) do |(date, ix), object|
      object[ix] = date.strftime('%m.%d')
    end
  end

  def country
    @country ||= if message_text.length == 2
      Country.by_iso2(message_text).first || raise(Error::CountryNotFound, message_text)
    else
      Country.by_name(message_text).first || raise(Error::CountryNotFound, message_text)
    end
  end
end
