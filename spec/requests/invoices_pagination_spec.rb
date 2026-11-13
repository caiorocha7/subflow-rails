require "rails_helper"

RSpec.describe "Paginação de faturas", type: :request do
  let(:account) { create(:account) }
  let(:admin) { create(:user, account:) }

  before do
    post login_path, params: { email: admin.email, password: "password-segura-123" }
  end

  it "pagina no backend sem expor faturas de outra empresa" do
    create_list(:invoice, 16, account:)
    other_invoice = create(:invoice)

    get invoices_path

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Página <strong>1</strong> de <strong>2</strong>")
    expect(response.body).not_to include("Fatura ##{other_invoice.id}")

    get invoices_path(page: 2)

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Página <strong>2</strong> de <strong>2</strong>")
  end
end
