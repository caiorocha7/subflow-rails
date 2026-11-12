# SubFlow

SaaS B2B de portfólio para gerir clientes, planos, assinaturas e cobranças recorrentes **simuladas**. Não processa pagamentos reais.

## Executar

1. Inicie o Docker Desktop.
2. `docker compose up --build`
3. Em outro terminal: `docker compose exec web bin/rails db:seed`
4. Abra http://localhost:3000.

Demo: `admin@acme.test` / `subflow-demo-2026`. O seed exibe no terminal um token Bearer novo para a API.

## Arquitetura

Monólito modular Rails 8.1: controllers finos, services para transições e cobrança, PostgreSQL como fonte de verdade e Sidekiq/Redis para jobs. Todo recurso privado é consultado a partir de `current_account` (web) ou da conta Bearer (API). Valores são armazenados em centavos.

Uma fatura possui índice único em `(subscription_id, period_start)`; transação e lock tornam a geração idempotente. Eventos usam `event_id` único, HMAC/timestamp e job idempotente. O cron Sidekiq executa diariamente às 06:00. MRR soma as assinaturas ativas e anual / 12; não é receita recebida.

## API e qualidade

Use `Authorization: Bearer TOKEN` nos endpoints `/api/v1/customers`, `/plans`, `/subscriptions` e `/invoices`. O webhook é `POST /api/v1/webhooks/payments` e requer HMAC SHA-256. Execute `bundle exec rspec`, `bundle exec rubocop` e `bundle exec brakeman -q`. Consulte [Arquitetura](docs/ARCHITECTURE.md), [Banco](docs/DATABASE.md), [API](docs/API.md) e [Decisões](docs/DECISIONS.md).
