class RegistrationsController < ApplicationController
  def new; end
  def create
    Account.transaction do
      account = Account.create!(name: params[:account_name], slug: params[:account_name].to_s.parameterize)
      user = account.users.create!(name: params[:name], email: params[:email]&.downcase, password: params[:password], role: :admin)
      reset_session; session[:user_id] = user.id
    end
    redirect_to root_path, notice: "Empresa criada. Vamos começar!"
  rescue ActiveRecord::RecordInvalid => e
    @error = e.record.errors.full_messages.to_sentence
    render :new, status: :unprocessable_entity
  end
end
