class PaymentEvent < ApplicationRecord
  belongs_to :account, optional: true
  belongs_to :invoice, optional: true
  validates :event_id, :event_type, :occurred_at, presence: true
  validates :event_type, inclusion: { in: %w[payment.succeeded payment.failed] }
end
