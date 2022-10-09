require 'date'

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    githubUser { Faker::Internet.username }
    trait :full do
      quantityFollowers { Faker::Number.between(from: 1, to: 5000) }
      quantityFollowing { Faker::Number.between(from: 1, to: 5000) }
      quantityStars { Faker::Number.between(from: 1, to: 50) }
      lastYearContributions { Faker::Number.between(from: 1, to: 10_000) }
      avatarUrl { Faker::Internet.url }
      organization { Faker::Company.name }
      localization { Faker::Address.city }
      shortUrl { Faker::Internet.url }
      lastScan { DateTime.now }
      # lastScan { '2022-10-09 00:13:53' }
    end
  end
end
