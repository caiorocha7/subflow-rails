class Api::V1::CustomersController < Api::V1::BaseController
  def index
    records = api_account.customers.order(:id).limit([params.fetch(:per_page, 25).to_i, 100].min)
    render json: { data: records.map { |r| customer_json(r) } }
  end
  def show = render json: { data: customer_json(api_account.customers.find(params[:id])) }
  def create
    customer = api_account.customers.create(customer_params)
    customer.persisted? ? render(json: { data: customer_json(customer) }, status: :created) : render_errors(customer)
  end
  private
  def customer_params = params.require(:customer).permit(:name, :email, :document, :phone)
  def customer_json(r) = { id: r.id, name: r.name, email: r.email, status: r.status, created_at: r.created_at }
end
