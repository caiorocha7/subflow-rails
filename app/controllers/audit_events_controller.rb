class AuditEventsController < ApplicationController
  before_action :require_authentication
  def index = @audit_events = current_account.audit_events.includes(:user).order(created_at: :desc).limit(100)
end
