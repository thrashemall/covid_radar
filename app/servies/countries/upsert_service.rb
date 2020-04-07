# frozen_string_literal: true

module Countries
  class UpsertService
    def call
      Country.bulk_import(countries, validate: false, on_duplicate_key_update: {
        conflict_target: %w[UPPER(iso2)],
        columns: %i[name slug]
      })
    end

    private

    def countries
      CovidApi::Cli.new.countries
    end
  end
end
