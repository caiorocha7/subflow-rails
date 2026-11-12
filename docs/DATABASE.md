# Modelo de dados
`Account` é o tenant. `User`, `Customer`, `Plan`, `Subscription`, `Invoice` e `AuditEvent` pertencem a ele. `PaymentEvent.event_id` e `(Invoice.subscription_id, period_start)` são únicos.
