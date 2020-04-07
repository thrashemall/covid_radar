# frozen_string_literal: true

class CountryImportWorker < ApplicationWorker
  LOCK = 'country:import'

  def perform
    Country.with_advisory_lock(LOCK, timeout_seconds: 0) do
      Countries::UpsertService.new.call
    end
  end
end
