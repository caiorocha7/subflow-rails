class PlansController < ApplicationController
  before_action :require_authentication
  before_action :require_admin, except: %i[index show]
  before_action :set_plan, only: %i[show edit update destroy]
  def index = @plans = current_account.plans.order(active: :desc, amount_cents: :asc)
  def show; end
  def new = @plan = current_account.plans.build
  def edit; end
  def create
    @plan = current_account.plans.build(plan_params)
    @plan.save ? redirect_to(@plan, notice: "Plano criado.") : render(:new, status: :unprocessable_entity)
  end
  def update
    @plan.update(plan_params) ? redirect_to(@plan, notice: "Plano atualizado.") : render(:edit, status: :unprocessable_entity)
  end
  def destroy
    @plan.update!(active: false); redirect_to plans_path, notice: "Plano desativado."
  end
  private
  def set_plan = @plan = current_account.plans.find(params[:id])
  def plan_params = params.require(:plan).permit(:name, :description, :amount_cents, :interval, :active)
end
