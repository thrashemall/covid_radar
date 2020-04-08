FactoryBot.define do
  factory :infection do
    country

    confirmed do
      rand(0...1_000)
    end

    confirmed_delta do
      rand(0...1_000)
    end

    confirmed_rate do
      rand(0..100)
    end

    deaths do
      rand(0...1_000)
    end

    deaths_delta do
      rand(0...1_000)
    end

    deaths_rate do
      rand(0..100)
    end

    recovered do
      rand(0...1_000)
    end

    recovered_delta do
      rand(0...1_000)
    end

    recovered_rate do
      rand(0..100)
    end

    sequence(:date) do |i|
      1.year.ago.next_day(i).to_date
    end
  end
end
