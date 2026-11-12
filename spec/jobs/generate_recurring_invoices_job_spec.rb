require "rails_helper"

RSpec.describe GenerateRecurringInvoicesJob do
  it "repetido no mesmo dia não duplica faturas" do
    subscription = create(:subscription, status: :active, next_billing_on: Date.current)
    2.times { described_class.perform_now(Date.current) }
    expect(subscription.invoices.where(period_start: Date.current).count).to eq(1)
  end

  it "não fatura assinatura cancelada" do
    subscription = create(:subscription, status: :canceled, next_billing_on: Date.current)
    described_class.perform_now(Date.current)
    expect(subscription.invoices).to be_empty
  end
end
