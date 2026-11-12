# API v1
Autentique com `Authorization: Bearer <token>`. Respostas são `{ data: ... }`; erros são `{ error: { code: ... } }`. Webhooks simulados usam `event_id`, `invoice_id`, `event_type`, `occurred_at` e HMAC de `timestamp.body` com `WEBHOOK_SECRET`.
