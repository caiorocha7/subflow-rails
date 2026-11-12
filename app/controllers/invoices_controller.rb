class InvoicesController < ApplicationController
  before_action :require_authentication
  before_action :set_invoice, only: %i[show simulate_payment]
  def index = @invoices = current_account.invoices.includes(:customer, :subscription).order(created_at: :desc)
  def show; end
  def simulate_payment
    require_admin
    type = params[:outcome] == "failed" ? "payment.failed" : "payment.succeeded"
    event = PaymentEvent.create!(account: current_account, invoice: @invoice, event_id: SecureRandom.uuid, event_type: type, occurred_at: Time.current, payload: { "invoice_id" => @invoice.id, "simulation" => true })
    ProcessPaymentEventJob.perform_later(event.id)
    redirect_to @invoice, notice: "Evento SIMULADO enfileirado para processamento."
  end
  private
  def set_invoice = @invoice = current_account.invoices.find(params[:id])
end
