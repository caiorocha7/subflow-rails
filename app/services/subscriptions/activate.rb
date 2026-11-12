module Subscriptions
  class Activate
    def initialize(subscription:, user: nil) = (@subscription, @user = subscription, user)
    def call
      raise ArgumentError, "Assinatura cancelada não pode ser ativada" if @subscription.canceled?
      @subscription.transaction do
        @subscription.update!(status: :active)
        AuditLogger.log(account: @subscription.account, user: @user, action: "subscription.activated", record: @subscription)
      end
      @subscription
    end
  end
end
