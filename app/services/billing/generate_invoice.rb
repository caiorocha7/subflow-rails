module Billing
  class GenerateInvoice
    def initialize(subscription:, period_start: nil)
      @subscription = subscription
      @period_start = period_start || Date.current
    end

    def call
      return unless @subscription.billable?
      Invoice.transaction do
        @subscription.lock!
        return unless @subscription.billable?
        period_end = @period_start + @subscription.billing_period - 1.day
        invoice = Invoice.create_or_find_by!(subscription: @subscription, period_start: @period_start) do |item|
          item.account = @subscription.account
          item.customer = @subscription.customer
          item.amount_cents = @subscription.plan.amount_cents
          item.currency = @subscription.plan.currency
          item.period_end = period_end
          item.due_on = @period_start
        end
        if invoice.previously_new_record?
          @subscription.update!(next_billing_on: @period_start + @subscription.billing_period)
          AuditLogger.log(account: @subscription.account, action: "invoice.generated", record: invoice)
        end
        invoice
      end
    end
  end
end
