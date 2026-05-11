FactoryBot.define do
  factory :author do
    sequence(:name) { |n| "#{Faker::Book.author} #{n}" }
    bio { Faker::Lorem.paragraph(sentence_count: 3) }
    birth_year { rand(1900..2000) }

    trait :with_books do
      after(:create) do |author|
        create_list(:book, 5, author: author)
      end
    end

    trait :without_bio do
      bio { nil }
    end

    trait :without_birth_year do
      birth_year { nil }
    end
  end
end
