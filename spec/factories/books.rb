FactoryBot.define do
  factory :book do
    title { Faker::Book.title }
    description { Faker::Lorem.paragraph(sentence_count: 5) }
    sequence(:isbn) { |n| "ISBN-#{n}-#{rand(1000..9999)}" }
    published_year { rand(1950..2025) }
    association :user
    association :author

    trait :recent do
      published_year { 2020 }
    end

    trait :classic do
      published_year { 1950 }
    end

    trait :without_description do
      description { nil }
    end

    trait :without_published_year do
      published_year { nil }
    end
  end
end

