FactoryBot.define do
  factory :tweet do
    message { Faker::Lorem.characters(number: 279) }
    user
  end
end
