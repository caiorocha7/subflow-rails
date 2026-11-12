class Api::V1::BaseController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound do
    render json: { error: { code: "not_found", message: "Registro não encontrado" } }, status: :not_found
  end

  before_action :authenticate_api!
  private
  attr_reader :api_account
  def authenticate_api!
    token = request.authorization.to_s.delete_prefix("Bearer ")
    @api_account = Account.find { |account| account.authenticate_api_token(token) } if token.present?
    render json: { error: { code: "unauthorized", message: "Token de API inválido" } }, status: :unauthorized unless @api_account
  end
  def render_errors(record, status: :unprocessable_entity)
    render json: { error: { code: "validation_error", details: record.errors.to_hash } }, status:
  end
end
