require "rails_helper"
RSpec.describe Billing::GenerateInvoice do
  it "é idempotente por assinatura e período" do
    account = Account.create!(name: "A", slug: "a")
    customer = account.customers.create!(name: "C", email: "c@example.test")
    plan = account.plans.create!(name: "P", amount_cents: 1000, interval: :monthly)
    subscription = account.subscriptions.create!(customer:, plan:, status: :active, starts_on: Date.current, next_billing_on: Date.current)
    2.times { described_class.new(subscription:).call }
    expect(subscription.invoices.count).to eq(1)
  end
end
