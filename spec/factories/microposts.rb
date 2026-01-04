FactoryBot.define do
  factory :micropost do
    title { Faker::Lorem.sentence(word_count: 3) }
    body  { Faker::Lorem.paragraph(sentence_count: 2) }
    association :user
  end
end
