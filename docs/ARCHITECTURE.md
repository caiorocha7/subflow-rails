# Arquitetura
O SubFlow é um monólito modular Rails, com controllers, models, services e jobs bem delimitados. Sidekiq executa geração de faturas e eventos em processo separado. PostgreSQL aplica chaves estrangeiras e índices únicos.
