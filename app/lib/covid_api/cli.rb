# frozen_string_literal: true

module CovidApi
  class Cli
    STATUS_CONFIRMED = :confirmed
    STATUS_RECOVERED = :recovered
    STATUS_DEATHS = :deaths
    STATUSES = [STATUS_CONFIRMED, STATUS_RECOVERED, STATUS_DEATHS].freeze

    def countries
      @countries ||= connection.get('/countries').body.map do |row|
        {
          name: row.fetch('Country'),
          slug: row.fetch('Slug'),
          iso2: row.fetch('ISO2')
        }
      end
    end

    def infections(country_slug, status)
      response = connection.get("/country/#{country_slug}/status/#{status}").body

      response.group_by { |row| row.fetch('Date') }.each_with_object([]) do |(date, group), object|
        object.push(
          date: date.to_date,
          status => group.sum { |r| r.fetch('Cases') }
        )
      end
    end

    private

    def connection
      @connection ||= Connection.new
    end
  end
end
