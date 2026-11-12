class Api::V1::InvoicesController < Api::V1::BaseController
  def index = render json: { data: api_account.invoices.order(created_at: :desc).map { |r| invoice_json(r) } }
  def show = render json: { data: invoice_json(api_account.invoices.find(params[:id])) }
  private
  def invoice_json(r) = { id: r.id, subscription_id: r.subscription_id, customer_id: r.customer_id, amount_cents: r.amount_cents, currency: r.currency, status: r.status, due_on: r.due_on, period_start: r.period_start, period_end: r.period_end }
end
