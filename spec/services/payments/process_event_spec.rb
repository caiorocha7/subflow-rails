require "rails_helper"

RSpec.describe Payments::ProcessEvent do
  let(:invoice) { create(:invoice) }

  it "marca fatura como paga apenas uma vez" do
    event = PaymentEvent.create!(account: invoice.account, invoice:, event_id: SecureRandom.uuid, event_type: "payment.succeeded", occurred_at: Time.current, payload: { "invoice_id" => invoice.id })
    2.times { described_class.new(event:).call }
    expect(invoice.reload).to be_paid
    expect(AuditEvent.where(action: "payment.succeeded", auditable_id: invoice.id).count).to eq(1)
  end

  it "não deixa evento de falha posterior reverter pagamento" do
    success = PaymentEvent.create!(account: invoice.account, invoice:, event_id: SecureRandom.uuid, event_type: "payment.succeeded", occurred_at: Time.current, payload: { "invoice_id" => invoice.id })
    described_class.new(event: success).call
    failed = PaymentEvent.create!(account: invoice.account, invoice:, event_id: SecureRandom.uuid, event_type: "payment.failed", occurred_at: 1.minute.ago, payload: { "invoice_id" => invoice.id })
    described_class.new(event: failed).call
    expect(invoice.reload).to be_paid
  end

  it "marca falha e assinatura como inadimplente" do
    event = PaymentEvent.create!(account: invoice.account, invoice:, event_id: SecureRandom.uuid, event_type: "payment.failed", occurred_at: Time.current, payload: { "invoice_id" => invoice.id })
    described_class.new(event:).call
    expect(invoice.reload).to be_failed
    expect(invoice.subscription.reload).to be_past_due
  end
end
