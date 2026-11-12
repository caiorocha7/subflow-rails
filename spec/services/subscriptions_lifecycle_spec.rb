require "rails_helper"

RSpec.describe "Ciclo de vida de assinaturas" do
  let(:account) { create(:account) }
  let(:customer) { create(:customer, account:) }
  let(:plan) { create(:plan, account:) }

  it "cria em trial e ativa uma assinatura" do
    subscription = Subscriptions::Create.new(account:, customer:, plan:).call
    expect(subscription).to be_trialing
    expect(Subscriptions::Activate.new(subscription:).call).to be_active
    expect(AuditEvent.where(action: "subscription.activated", auditable_id: subscription.id)).to exist
  end

  it "cancela sem permitir nova ativação" do
    subscription = create(:subscription, account:, customer:, plan:, status: :active)
    Subscriptions::Cancel.new(subscription:).call
    expect(subscription.reload).to be_canceled
    expect { Subscriptions::Activate.new(subscription:).call }.to raise_error(ArgumentError, /cancelada/)
  end

  it "rejeita plano inativo" do
    plan.update!(active: false)
    expect { Subscriptions::Create.new(account:, customer:, plan:).call }.to raise_error(ArgumentError, /inativo/)
  end
end
