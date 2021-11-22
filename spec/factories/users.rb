FactoryBot.define do
  factory :user do
    full_name { Faker::Name.name }
    password { Faker::Internet.password }
    sequence(:email) { |n| "#{Faker::Internet.username}#{n}@#{Faker::Internet.domain_name}" }
    sequence(:username) { |n| "#{Faker::Internet.username}#{n}" }
  end
end
