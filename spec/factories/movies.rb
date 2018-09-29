FactoryBot.define do
  factory :movie do
    title { Faker::Movie.quote }
    release_date { Faker::Date.between(50.years.ago, Date.today) }
  end
end
