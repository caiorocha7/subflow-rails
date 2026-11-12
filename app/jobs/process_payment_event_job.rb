class ProcessPaymentEventJob < ApplicationJob
  queue_as :payments
  retry_on ActiveRecord::Deadlocked, wait: 3.seconds, attempts: 5
  def perform(event_id) = Payments::ProcessEvent.new(event: PaymentEvent.find(event_id)).call
end
