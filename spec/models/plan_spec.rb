require "rails_helper"
RSpec.describe Plan, type: :model do
  it "converte um plano anual para MRR" do
    plan = described_class.new(name: "Anual", amount_cents: 120_000, currency: "BRL", interval: :yearly)
    expect(plan.monthly_amount_cents).to eq(10_000)
  end
end
