class DashboardController < ApplicationController
  before_action :require_authentication
  def show
    @mrr_cents = current_account.mrr_cents
    @counts = { active: current_account.subscriptions.active.count, canceled: current_account.subscriptions.canceled.count,
      open: current_account.invoices.open.count, paid: current_account.invoices.paid.count, failed: current_account.invoices.failed.count,
      customers: current_account.customers.active.count }
    @events = current_account.audit_events.order(created_at: :desc).limit(8)
  end
end
