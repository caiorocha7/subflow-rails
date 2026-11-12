require "rails_helper"

RSpec.describe "Gestão web de clientes e planos", type: :request do
  let(:account) { create(:account) }
  let(:admin) { create(:user, account:) }

  before do
    post login_path, params: { email: admin.email, password: "password-segura-123" }
  end

  it "cria e desativa cliente preservando o registro" do
    expect do
      post customers_path, params: { customer: { name: "Cliente Web", email: "cliente-web@example.test", status: "active" } }
    end.to change(account.customers, :count).by(1)
    customer = account.customers.find_by!(email: "cliente-web@example.test")
    delete customer_path(customer)
    expect(customer.reload).to be_inactive
  end

  it "cria e desativa plano preservando histórico" do
    expect do
      post plans_path, params: { plan: { name: "Plano Web", amount_cents: 12_000, interval: "monthly", active: true } }
    end.to change(account.plans, :count).by(1)
    plan = account.plans.find_by!(name: "Plano Web")
    delete plan_path(plan)
    expect(plan.reload).not_to be_active
  end
end
