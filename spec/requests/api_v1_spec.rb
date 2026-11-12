require "rails_helper"

RSpec.describe "API v1", type: :request do
  let(:account) { create(:account) }
  let(:customer) { create(:customer, account:) }
  let(:other_customer) { create(:customer) }
  let(:token) { account.issue_api_token! }
  let(:headers) { { "Authorization" => "Bearer #{token}" } }

  it "rejeita chamadas sem Bearer token" do
    get "/api/v1/customers"
    expect(response).to have_http_status(:unauthorized)
  end

  it "lista somente recursos do token autenticado" do
    customer
    other_customer
    get "/api/v1/customers", headers: headers
    expect(response).to have_http_status(:ok)
    expect(response.parsed_body.fetch("data").map { |item| item.fetch("id") }).to eq([ customer.id ])
  end

  it "não expõe cliente de outro tenant" do
    get "/api/v1/customers/#{other_customer.id}", headers: headers
    expect(response).to have_http_status(:not_found)
  end

  it "cria cliente no tenant do token, sem aceitar account_id externo" do
    expect do
      post "/api/v1/customers", params: { customer: { name: "API", email: "api@example.test", account_id: other_customer.account_id } }, headers: headers
    end.to change(account.customers, :count).by(1)
    expect(Customer.find_by!(email: "api@example.test").account).to eq(account)
  end
end
