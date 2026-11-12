module Subscriptions
  class Cancel
    def initialize(subscription:, user: nil) = (@subscription, @user = subscription, user)
    def call
      return @subscription if @subscription.canceled?
      @subscription.transaction do
        @subscription.update!(status: :canceled, canceled_at: Time.current)
        AuditLogger.log(account: @subscription.account, user: @user, action: "subscription.canceled", record: @subscription)
      end
      @subscription
    end
  end
end
