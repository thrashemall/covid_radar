# frozen_string_literal: true

# == Schema Information
#
# Table name: infections
#
#  id                 :bigint           not null, primary key
#  confirmed          :bigint           default(0)
#  confirmed_delta    :bigint           default(0)
#  confirmed_notified :bigint
#  confirmed_rate     :integer          default(0)
#  date               :date             not null
#  deaths             :bigint           default(0)
#  deaths_delta       :bigint           default(0)
#  deaths_rate        :integer          default(0)
#  recovered          :bigint           default(0)
#  recovered_delta    :bigint           default(0)
#  recovered_rate     :integer          default(0)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  country_id         :bigint
#
class Infection < ApplicationRecord
  scope :ordered, -> { order(date: :desc) }

  belongs_to :country

  def summary
    <<~DOC
      Confirmed: #{Formatter.number(confirmed)} (#{Formatter.signed_number(confirmed_delta)} / #{Formatter.signed_number(confirmed_rate)}%)
      Recovered: #{Formatter.number(recovered)} (#{Formatter.signed_number(recovered_delta)} / #{Formatter.signed_number(recovered_rate)}%)
      Deaths: #{Formatter.number(deaths)} (#{Formatter.signed_number(deaths_delta)} / #{Formatter.signed_number(deaths_rate)}%)
    DOC
  end
end
