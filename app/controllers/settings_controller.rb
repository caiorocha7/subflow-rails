class SettingsController < ApplicationController
  before_action :require_authentication, :require_admin
  def show; end
  def update
    current_account.update!(settings_params)
    redirect_to settings_path, notice: "Configurações atualizadas."
  rescue ActiveRecord::RecordInvalid
    render :show, status: :unprocessable_entity
  end
  private
  def settings_params = params.require(:account).permit(:name)
end
