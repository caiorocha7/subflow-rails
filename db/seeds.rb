# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# Dados exclusivamente fictícios para demonstração local.
account = Account.find_or_create_by!(slug: "acme-digital") { |a| a.name = "Acme Digital" }
admin = account.users.find_or_initialize_by(email: "admin@acme.test")
admin.update!(name: "Ana Martins", password: "subflow-demo-2026", role: :admin)
token = account.issue_api_token!
starter = account.plans.find_or_create_by!(name: "Starter") { |p| p.description = "Para operações em crescimento"; p.amount_cents = 9900; p.interval = :monthly }
growth = account.plans.find_or_create_by!(name: "Growth") { |p| p.description = "Para equipes em escala"; p.amount_cents = 24900; p.interval = :monthly }
business = account.plans.find_or_create_by!(name: "Business") { |p| p.description = "Para empresas consolidadas"; p.amount_cents = 239900; p.interval = :yearly }
customers = [ [ "Aurora Studio", "financeiro@aurora.test" ], [ "Norte Labs", "contato@nortelabs.test" ], [ "Ponto Azul", "ops@pontoazul.test" ] ].map { |name, email| account.customers.find_or_create_by!(email:) { |c| c.name = name; c.status = :active } }
subscriptions = [ [ customers[0], starter, :active ], [ customers[1], growth, :active ], [ customers[2], business, :past_due ] ].map { |customer, plan, status| account.subscriptions.find_or_create_by!(customer:, plan:) { |s| s.status = status; s.starts_on = Date.current - 1.month; s.next_billing_on = Date.current } }
subscriptions.each { |subscription| Billing::GenerateInvoice.new(subscription:, period_start: subscription.next_billing_on).call }
puts "Seeds concluídos. Login: admin@acme.test / subflow-demo-2026 | API token: #{token}"
