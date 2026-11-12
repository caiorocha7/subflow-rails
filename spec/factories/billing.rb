FactoryBot.define do
  factory :customer do
    association :account
    sequence(:name) { |n| "Cliente #{n}" }
    sequence(:email) { |n| "cliente#{n}@example.test" }
    status { :active }
  end

  factory :plan do
    association :account
    sequence(:name) { |n| "Plano #{n}" }
    amount_cents { 9_900 }
    interval { :monthly }
    active { true }
  end

  factory :subscription do
    association :account
    customer { association :customer, account: }
    plan { association :plan, account: }
    status { :trialing }
    starts_on { Date.current }
    next_billing_on { Date.current }
  end

  factory :invoice do
    association :account
    subscription { association :subscription, account: }
    customer { subscription.customer }
    amount_cents { subscription.plan.amount_cents }
    status { :open }
    period_start { Date.current }
    period_end { Date.current + 1.month - 1.day }
    due_on { Date.current }
  end
end
