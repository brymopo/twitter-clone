# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require "faker"

$counter = 0

test_user = User.create(
  full_name: "John Doe",
  password: "abc123",
  email: "user@example.com",
  username: "john-doe"
)

puts "Create test user - Done"

def create_user
  $counter += 1
  User.create(
    full_name: Faker::Name.name,
    password: Faker::Internet.password,
    email: "#{Faker::Internet.username}#{$counter}@#{Faker::Internet.domain_name}",
    username: "#{Faker::Internet.username separators: %w(-)}#{$counter}"
  )
end

def create_tweet(user)
  created_at = Faker::Time.between(from: Date.today - 60, to: Date.today)
  Tweet.create(
    message: Faker::Lorem.paragraph.first(279),
    user_id: user.id,
    created_at: created_at.to_s
  )
end

users_list = 50.times.map { create_user }
users_list << test_user

puts "Create users lists - DONE!"

users_indices = (0...users_list.size).to_a

users_list.each_with_index do |user, ind|
  puts "-" * 20
  puts "Seeding data user: #{ind}"
  puts "Creating user tweets"

  number_of_tweets = Random.rand(15..30)
  number_of_tweets.times.map { create_tweet(user) }

  puts "Adding followers"
  number_of_followers = Random.rand(15..25)
  users_indices.sample(number_of_followers).each do |val|
    next if val == ind

    Follow.create(followed_id: user.id, follower_id: users_list[val].id)
  end
  puts "User done!"
end
