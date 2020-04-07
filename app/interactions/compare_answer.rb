class CompareAnswer < ApplicationInteraction
  INFECTION_LIMIT = 10

  def reply(api)
    validate!
    api.send_photo(chat_id: message_chat.id, photo: Faraday::UploadIO.new(StringIO.new(chart), 'image/png'))
  end

  private

  def validate!
    if countries.empty?
      raise Error::Custom, <<~MSG
        Enter two valid country codes to compare, for example:
        #{Country::SAMPLE_CODES.sample(2).join(' ')}
        #{Country::SAMPLE_CODES.sample(2).join(', ')}
      MSG
    end

    if countries.one?
      raise Error::Custom, <<~MSG
        Enter two valid country codes to compare (got one - #{countries.first.iso2}), for example:
        #{Country::SAMPLE_CODES.sample(2).join(' ')}
        #{Country::SAMPLE_CODES.sample(2).join(', ')}
      MSG
    end
  end

  def chart
    g = Gruff::Line.new(1600)
    g.font = Rails.root.join('vendor', 'fonts', 'HelveticaMedium.ttf').to_s
    g.title = 'Compare Trends'
    g.data base_country.name, base_infections.map(&:confirmed)
    g.data target_country.name, target_infections.map(&:confirmed)
    g.to_blob('PNG')
  end

  def base_infections
    @base_infections ||= base_country.infections.where('date >= ?', base_date).order(date: :asc).limit(INFECTION_LIMIT)
  end

  def target_infections
    @target_infections ||= target_country.infections.order(date: :desc).limit(INFECTION_LIMIT).reverse
  end

  def country_codes
    @country_codes ||= message_text.gsub(/[[:punct:]]/, "\s").gsub(/\s+/, ',').split(',').first(2)
  end

  def base_country
    @base_country ||= countries.max_by(&:confirmed)
  end

  def target_country
    @target_country ||= countries.min_by(&:confirmed)
  end

  def countries
    @countries ||= Country
      .by_iso2(country_codes[0])
      .or(Country.by_iso2(country_codes[1]))
      .select('*')
      .select_confirmed
  end

  # @return [String] date
  def base_date
    return @base_date if defined?(@base_date)

    sql = <<~SQL
      SELECT date
      FROM infections
      WHERE country_id = #{base_country.id} AND confirmed <= #{target_infections[0]&.confirmed.to_i}
      ORDER BY confirmed DESC
      LIMIT 1
    SQL

    @base_date ||= ApplicationRecord.connection.select_value(sql, 'date')&.to_date
  end
end
