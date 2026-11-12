class GenerateRecurringInvoicesJob < ApplicationJob
  queue_as :default
  retry_on ActiveRecord::Deadlocked, wait: 5.seconds, attempts: 5
  def perform(date = Date.current)
    Subscription.where.not(status: :canceled).where("next_billing_on <= ?", date).find_each do |subscription|
      Billing::GenerateInvoice.new(subscription:, period_start: subscription.next_billing_on).call
    end
  end
end
