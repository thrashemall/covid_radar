# frozen_string_literal: true

module Infections
  class UpsertService
    def call
      each_country_status do |country, status|
        ApplicationRecord.transaction do
          upsert(country, status)
          calculate(country, status)
        end
      end
    end

    private

    def each_country_status
      Country.all.each do |country|
        CovidApi::Cli::STATUSES.each do |status|
          yield(country, status)
        end
      end
    end

    def upsert(country, status)
      Infection.bulk_import(inflections(country, status), validate: false, on_duplicate_key_update: {
        conflict_target: %i[country_id date],
        columns: [status]
      })
    end

    def calculate(country, status)
      ApplicationRecord.connection.execute <<~SQL
        UPDATE infections current SET
               #{status}_delta = current.#{status} - COALESCE(past.#{status}, current.#{status}),
               #{status}_rate = ROUND((current.#{status} - COALESCE(past.#{status}, current.#{status})) / NULLIF(current.#{status}::float, 0) * 100)
        FROM infections past
        WHERE current.country_id = #{country.id}
        AND current.country_id = past.country_id
        AND past.date + integer '1' = current.date
      SQL
    end

    def inflections(country, status)
      CovidApi::Cli.new.infections(country.slug_url_safe, status).map do |row|
        row.merge(country_id: country.id)
      end
    end
  end
end
