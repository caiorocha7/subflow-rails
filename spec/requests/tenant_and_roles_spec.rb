require "rails_helper"

RSpec.describe "Tenancy e permissões", type: :request do
  def sign_in(user)
    post login_path, params: { email: user.email, password: "password-segura-123" }
  end

  let(:account) { create(:account) }
  let(:admin) { create(:user, account:, role: :admin) }
  let(:member) { create(:user, account:, role: :member) }
  let(:other_customer) { create(:customer) }
  let(:other_plan) { create(:plan) }

  it "não permite visualizar cliente de outro tenant" do
    sign_in(admin)
    get customer_path(other_customer)
    expect(response).to redirect_to(root_path)
  end

  it "não permite visualizar plano de outro tenant" do
    sign_in(admin)
    get plan_path(other_plan)
    expect(response).to redirect_to(root_path)
  end

  it "impede member de criar cliente" do
    sign_in(member)
    expect { post customers_path, params: { customer: { name: "Novo", email: "novo@example.test", status: "active" } } }.not_to change(Customer, :count)
    expect(response).to redirect_to(root_path)
  end

  it "permite member consultar recursos da própria empresa" do
    customer = create(:customer, account:)
    sign_in(member)
    get customer_path(customer)
    expect(response).to have_http_status(:ok)
  end

  it "não permite associar assinatura com recursos de outro tenant" do
    customer = create(:customer, account:)
    sign_in(admin)
    expect { post subscriptions_path, params: { subscription: { customer_id: customer.id, plan_id: other_plan.id, starts_on: Date.current } } }.not_to change(Subscription, :count)
    expect(response).to redirect_to(root_path)
  end
end
