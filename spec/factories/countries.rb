FactoryBot.define do
  factory :country do
    sequence(:iso2) do |i|
      format("%02i", i)
    end

    sequence(:name) do |i|
      "Country ##{i}"
    end

    sequence(:slug) do |i|
      "country-#{i}"
    end
  end
end
