# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    # Use a sequence for unique attributes like email
    sequence(:email) { |n| "user#{n}@example.com" }
    username { Faker::Internet.username(specifier: 5..8) }
    password { "password123" }
    admin { false }

    trait :admin do
      admin { true }
    end

    factory :admin_user, traits: [ :admin ]
  end
end
