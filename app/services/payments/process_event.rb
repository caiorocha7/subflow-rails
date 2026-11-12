module Payments
  class ProcessEvent
    def initialize(event:) = @event = event
    def call
      return @event if @event.processed_at?
      PaymentEvent.transaction do
        @event.lock!
        return @event if @event.processed_at?
        invoice = @event.invoice || Invoice.find_by(id: @event.payload["invoice_id"])
        raise ActiveRecord::RecordNotFound, "Cobrança não encontrada" unless invoice
        raise PunditLike::NotAuthorized if @event.account && invoice.account_id != @event.account_id
        unless invoice.terminal? || (@event.event_type == "payment.failed" && invoice.failed?)
          if @event.event_type == "payment.succeeded"
            invoice.update!(status: :paid, paid_at: Time.current)
            invoice.subscription.update!(status: :active) unless invoice.subscription.canceled?
            action = "payment.succeeded"
          else
            invoice.update!(status: :failed)
            invoice.subscription.update!(status: :past_due) unless invoice.subscription.canceled?
            action = "payment.failed"
          end
          AuditLogger.log(account: invoice.account, action:, record: invoice, correlation_id: @event.event_id)
        end
        @event.update!(invoice:, account: invoice.account, processed_at: Time.current)
      end
      @event
    rescue => e
      @event.update!(processing_error: e.message) if @event.persisted? && !@event.processed_at?
      raise
    end
  end
end
