module Subscriptions
  class Create
    def initialize(account:, customer:, plan:, starts_on: Date.current, user: nil)
      @account, @customer, @plan, @starts_on, @user = account, customer, plan, starts_on, user
    end

    def call
      raise ArgumentError, "Plano inativo" unless @plan.active?
      Subscription.transaction do
        subscription = @account.subscriptions.create!(customer: @customer, plan: @plan, status: :trialing,
          starts_on: @starts_on, next_billing_on: @starts_on)
        AuditLogger.log(account: @account, user: @user, action: "subscription.created", record: subscription)
        subscription
      end
    end
  end
end
