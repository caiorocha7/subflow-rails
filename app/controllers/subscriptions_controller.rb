class SubscriptionsController < ApplicationController
  before_action :require_authentication
  before_action :require_admin, except: %i[index show]
  before_action :set_subscription, only: %i[show activate cancel]
  def index = @subscriptions = current_account.subscriptions.includes(:customer, :plan).order(created_at: :desc)
  def show = @invoices = @subscription.invoices.order(period_start: :desc)
  def new
    @subscription = current_account.subscriptions.build(starts_on: Date.current)
    form_options
  end
  def create
    @subscription = Subscriptions::Create.new(account: current_account, customer: current_account.customers.find(subscription_params[:customer_id]), plan: current_account.plans.find(subscription_params[:plan_id]), starts_on: subscription_params[:starts_on].to_date, user: current_user).call
    redirect_to @subscription, notice: "Assinatura criada como período de teste."
  rescue ActiveRecord::RecordInvalid, ArgumentError => e
    @subscription = current_account.subscriptions.build(subscription_params); @subscription.errors.add(:base, e.message); form_options
    render :new, status: :unprocessable_entity
  end
  def activate
    Subscriptions::Activate.new(subscription: @subscription, user: current_user).call
    redirect_to @subscription, notice: "Assinatura ativada."
  rescue ArgumentError => e
    redirect_to @subscription, alert: e.message
  end
  def cancel
    Subscriptions::Cancel.new(subscription: @subscription, user: current_user).call
    redirect_to @subscription, notice: "Assinatura cancelada."
  end
  private
  def set_subscription = @subscription = current_account.subscriptions.find(params[:id])
  def form_options; @customers = current_account.customers.active.order(:name); @plans = current_account.plans.where(active: true).order(:name); end
  def subscription_params = params.require(:subscription).permit(:customer_id, :plan_id, :starts_on)
end
