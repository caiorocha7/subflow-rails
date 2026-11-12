class SendBillingNotificationJob < ApplicationJob
  queue_as :default
  def perform(invoice_id)
    invoice = Invoice.find(invoice_id)
    Rails.logger.info(event: "billing.notification", invoice_id: invoice.id, status: invoice.status, simulation: true)
  end
end
