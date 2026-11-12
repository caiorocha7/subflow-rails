class CustomersController < ApplicationController
  before_action :require_authentication
  before_action :require_admin, except: %i[index show]
  before_action :set_customer, only: %i[show edit update destroy]
  def index
    @customers = current_account.customers.order(created_at: :desc)
    @customers = @customers.where(status: params[:status]) if params[:status].present?
    @customers = @customers.where("name ILIKE :query OR email ILIKE :query", query: "%#{params[:q]}%") if params[:q].present?
    @customers = @customers.limit(50)
  end
  def show; end
  def new = @customer = current_account.customers.build
  def edit; end
  def create
    @customer = current_account.customers.build(customer_params)
    @customer.save ? redirect_to(@customer, notice: "Cliente criado.") : render(:new, status: :unprocessable_entity)
  end
  def update
    @customer.update(customer_params) ? redirect_to(@customer, notice: "Cliente atualizado.") : render(:edit, status: :unprocessable_entity)
  end
  def destroy
    @customer.inactive!; redirect_to customers_path, notice: "Cliente desativado; o histórico foi preservado."
  end
  private
  def set_customer = @customer = current_account.customers.find(params[:id])
  def customer_params = params.require(:customer).permit(:name, :email, :document, :phone, :status)
end
