require "rails_helper"

RSpec.describe "Webhook de pagamentos", type: :request do
  let(:invoice) { create(:invoice) }
  let(:timestamp) { Time.current.to_i.to_s }

  def post_webhook(payload, signature: nil)
    body = payload.to_json
    signature ||= OpenSSL::HMAC.hexdigest("SHA256", ENV.fetch("WEBHOOK_SECRET", "development-webhook-secret"), "#{timestamp}.#{body}")
    post "/api/v1/webhooks/payments", params: body, headers: { "CONTENT_TYPE" => "application/json", "X-Subflow-Timestamp" => timestamp, "X-Subflow-Signature" => signature }
  end

  it "aceita evento válido e persiste evento do tenant da fatura" do
    payload = { event_id: SecureRandom.uuid, invoice_id: invoice.id, event_type: "payment.succeeded", occurred_at: Time.current.iso8601, payload: { simulation: true } }
    expect { post_webhook(payload) }.to change(PaymentEvent, :count).by(1)
    expect(response).to have_http_status(:accepted), response.body
    expect(PaymentEvent.last.account).to eq(invoice.account)
  end

  it "rejeita assinatura HMAC inválida" do
    payload = { event_id: SecureRandom.uuid, invoice_id: invoice.id, event_type: "payment.succeeded", occurred_at: Time.current.iso8601 }
    post_webhook(payload, signature: "invalida")
    expect(response).to have_http_status(:unauthorized)
    expect(PaymentEvent.count).to eq(0)
  end

  it "mantém somente um registro para evento duplicado" do
    payload = { event_id: SecureRandom.uuid, invoice_id: invoice.id, event_type: "payment.succeeded", occurred_at: Time.current.iso8601 }
    2.times { post_webhook(payload) }
    expect(PaymentEvent.where(event_id: payload[:event_id]).count).to eq(1)
    expect(response).to have_http_status(:accepted), response.body
  end
end
