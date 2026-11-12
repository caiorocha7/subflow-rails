class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  helper_method :current_user, :current_account, :signed_in?
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from PunditLike::NotAuthorized, with: :not_authorized

  private

  def current_user = @current_user ||= User.find_by(id: session[:user_id])
  def current_account = current_user&.account
  def signed_in? = current_user.present?

  def require_authentication
    return if signed_in?
    redirect_to login_path, alert: "Faça login para continuar."
  end

  def require_admin
    raise PunditLike::NotAuthorized unless current_user&.admin?
  end

  def not_found
    respond_to { |format| format.html { redirect_to root_path, alert: "Registro não encontrado." }; format.json { render json: { error: { code: "not_found" } }, status: :not_found } }
  end

  def not_authorized
    respond_to { |format| format.html { redirect_to root_path, alert: "Você não possui permissão para esta ação." }; format.json { render json: { error: { code: "forbidden" } }, status: :forbidden } }
  end
end
