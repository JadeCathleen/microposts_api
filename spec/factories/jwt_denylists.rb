FactoryBot.define do
  factory :jwt_denylist do
    jti { "MyString" }
    exp { "2026-01-04 18:14:57" }
  end
end
