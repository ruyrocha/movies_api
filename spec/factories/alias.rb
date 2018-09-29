FactoryBot.define do
  factory :alias do
    name { Faker::Internet.username }
  end
end
