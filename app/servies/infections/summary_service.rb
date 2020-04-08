# frozen_string_literal: true

module Infections
  class SummaryService
    attr_accessor :infection

    def initialize(infection)
      @infection = infection
    end

    def call
      <<~DOC
        Confirmed: #{confirmed} (#{confirmed_delta} / #{confirmed_rate})
        Recovered: #{recovered} (#{recovered_delta} / #{recovered_rate})
        Deaths: #{deaths} (#{deaths_delta} / #{deaths_rate})
      DOC
    end

    private

    def confirmed
      Formatter.number(infection.confirmed.to_i)
    end

    def recovered
      Formatter.number(infection.recovered.to_i)
    end

    def deaths
      Formatter.number(infection.deaths.to_i)
    end

    def confirmed_delta
      Formatter.signed_number(infection.confirmed_delta.to_i, &Formatter.method(:number))
    end

    def recovered_delta
      Formatter.signed_number(infection.recovered_delta.to_i, &Formatter.method(:number))
    end

    def deaths_delta
      Formatter.signed_number(infection.deaths_delta.to_i, &Formatter.method(:number))
    end

    def confirmed_rate
      Formatter.signed_number(infection.confirmed_rate.to_i, &Formatter.method(:percentage))
    end

    def recovered_rate
      Formatter.signed_number(infection.recovered_rate.to_i, &Formatter.method(:percentage))
    end

    def deaths_rate
      Formatter.signed_number(infection.deaths_rate.to_i, &Formatter.method(:percentage))
    end
  end
end
