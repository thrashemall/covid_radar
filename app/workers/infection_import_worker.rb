# frozen_string_literal: true

class InfectionImportWorker < ApplicationWorker
  LOCK = 'infection:import'

  def perform
    Infection.with_advisory_lock(LOCK, timeout_seconds: 0) do
      Infections::UpsertService.new.call
    end
  end
end
