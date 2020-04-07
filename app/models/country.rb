# frozen_string_literal: true

# == Schema Information
#
# Table name: countries
#
#  id         :bigint           not null, primary key
#  iso2       :string
#  name       :string
#  slug       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Country < ApplicationRecord
  SAMPLE_CODES = %w[
    US ES IT DE FR CN IR GB TR CH BE NL CA AT BR RU BY
  ].freeze

  scope :by_iso2, ->(code) { where('iso2 = UPPER(?)', code.to_s.squish) }
  scope :by_name, ->(name) { where(name: name.to_s.squish) }

  scope :select_confirmed, -> do
    select <<~SQL
      (SELECT confirmed FROM infections WHERE country_id = countries.id ORDER BY date DESC limit 1) AS confirmed
    SQL
  end

  has_many :infections, dependent: :delete_all

  # some countries (like RE) has urf-8 chars in
  # slug like "réunion"
  def slug_url_safe
    CGI.escape(slug)
  end
end
