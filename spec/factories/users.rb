FactoryBot.define do
  factory :user do
    association :account
    sequence(:name) { |n| "Pessoa #{n}" }
    sequence(:email) { |n| "pessoa#{n}@example.test" }
    password { "password-segura-123" }
    role { :admin }
  end
end
