FactoryBot.define do
  factory :account do
    sequence(:name) { |n| "Empresa #{n}" }
    sequence(:slug) { |n| "empresa-#{n}" }
  end
end
