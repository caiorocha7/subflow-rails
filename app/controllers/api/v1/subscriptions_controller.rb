class Api::V1::SubscriptionsController < Api::V1::BaseController
  def index = render json: { data: api_account.subscriptions.includes(:customer, :plan).map { |r| subscription_json(r) } }
  def show = render json: { data: subscription_json(api_account.subscriptions.find(params[:id])) }
  def create
    subscription = Subscriptions::Create.new(account: api_account, customer: api_account.customers.find(params.dig(:subscription, :customer_id)), plan: api_account.plans.find(params.dig(:subscription, :plan_id)), starts_on: (params.dig(:subscription, :starts_on) || Date.current).to_date).call
    render json: { data: subscription_json(subscription) }, status: :created
  rescue ActiveRecord::RecordInvalid, ArgumentError => e
    render json: { error: { code: "validation_error", message: e.message } }, status: :unprocessable_entity
  end
  def cancel
    subscription = Subscriptions::Cancel.new(subscription: api_account.subscriptions.find(params[:id])).call
    render json: { data: subscription_json(subscription) }
  end
  private
  def subscription_json(r) = { id: r.id, customer_id: r.customer_id, plan_id: r.plan_id, status: r.status, starts_on: r.starts_on, next_billing_on: r.next_billing_on }
end
