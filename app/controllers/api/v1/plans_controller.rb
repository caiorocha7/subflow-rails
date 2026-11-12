class Api::V1::PlansController < Api::V1::BaseController
  def index = render json: { data: api_account.plans.order(:id).map { |r| plan_json(r) } }
  def show = render json: { data: plan_json(api_account.plans.find(params[:id])) }
  private
  def plan_json(r) = { id: r.id, name: r.name, description: r.description, amount_cents: r.amount_cents, currency: r.currency, interval: r.interval, active: r.active }
end
