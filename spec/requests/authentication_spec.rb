require "rails_helper"

RSpec.describe "Autenticação", type: :request do
  let!(:user) { create(:user, password: "password-segura-123") }

  it "redireciona visitantes da área privada para login" do
    get root_path
    expect(response).to redirect_to(login_path)
  end

  it "autentica credenciais válidas e exibe dashboard" do
    post login_path, params: { email: user.email, password: "password-segura-123" }
    expect(response).to redirect_to(root_path)
    follow_redirect!
    expect(response.body).to include("Bom trabalho")
  end

  it "rejeita senha inválida" do
    post login_path, params: { email: user.email, password: "incorreta" }
    expect(response).to have_http_status(:unprocessable_entity)
    expect(response.body).to include("E-mail ou senha inválidos")
  end

  it "encerra a sessão" do
    post login_path, params: { email: user.email, password: "password-segura-123" }
    delete logout_path
    expect(response).to redirect_to(login_path)
    get root_path
    expect(response).to redirect_to(login_path)
  end
end
