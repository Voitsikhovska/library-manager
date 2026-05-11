FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
    password_confirmation { "password123" }

    trait :with_books do
      after(:create) do |user|
        create_list(:book, 3, user: user)
      end
    end
  end
end
