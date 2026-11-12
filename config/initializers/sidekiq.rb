Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch("REDIS_URL", "redis://redis:6379/0") }
end
Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch("REDIS_URL", "redis://redis:6379/0") }
end
Sidekiq::Cron::Job.load_from_hash("recurring_invoices" => { "cron" => "0 6 * * *", "class" => "GenerateRecurringInvoicesJob" }) if defined?(Sidekiq::Cron)
