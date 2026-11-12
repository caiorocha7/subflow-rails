class Api::V1::WebhooksController < ActionController::API
  def payments
    raw_body = request.raw_post
    return render(json: { error: { code: "invalid_signature" } }, status: :unauthorized) unless valid_signature?(raw_body)
    data = JSON.parse(raw_body)
    return render(json: { error: { code: "invalid_timestamp" } }, status: :unprocessable_entity) if Time.zone.parse(data.fetch("occurred_at")) < 5.minutes.ago
    event = PaymentEvent.create_or_find_by!(event_id: data.fetch("event_id")) do |record|
      record.invoice = Invoice.find(data.fetch("invoice_id"))
      record.account = record.invoice.account
      record.event_type = data.fetch("event_type")
      record.occurred_at = Time.zone.parse(data.fetch("occurred_at"))
      record.payload = data.fetch("payload", {})
    end
    ProcessPaymentEventJob.perform_later(event.id) unless event.processed_at?
    render json: { data: { event_id: event.event_id, status: "accepted", simulation: true } }, status: :accepted
  rescue JSON::ParserError, KeyError, ActiveRecord::RecordInvalid => e
    render json: { error: { code: "invalid_payload", message: e.message } }, status: :unprocessable_entity
  end
  private
  def valid_signature?(body)
    timestamp = request.headers["X-Subflow-Timestamp"].to_s
    return false if timestamp.blank? || (Time.current.to_i - timestamp.to_i).abs > 300
    expected = OpenSSL::HMAC.hexdigest("SHA256", ENV.fetch("WEBHOOK_SECRET", "development-webhook-secret"), "#{timestamp}.#{body}")
    ActiveSupport::SecurityUtils.secure_compare(expected, request.headers["X-Subflow-Signature"].to_s)
  end
end
