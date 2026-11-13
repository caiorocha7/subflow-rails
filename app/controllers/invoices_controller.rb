class InvoicesController < ApplicationController
  before_action :require_authentication
  before_action :set_invoice, only: %i[show simulate_payment]
  def index
    @per_page = 15
    @page = [ params.fetch(:page, 1).to_i, 1 ].max
    scope = current_account.invoices.includes(:customer, subscription: :plan).order(created_at: :desc, id: :desc)
    @total_pages = [ (scope.count.to_f / @per_page).ceil, 1 ].max
    @page = @total_pages if @page > @total_pages
    @invoices = scope.offset((@page - 1) * @per_page).limit(@per_page)
  end
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
