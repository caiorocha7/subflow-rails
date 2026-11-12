class Invoice < ApplicationRecord
  belongs_to :account
  belongs_to :subscription
  belongs_to :customer
  has_many :payment_events, dependent: :restrict_with_exception
  enum :status, { open: 0, paid: 1, failed: 2, void: 3 }
  validates :amount_cents, numericality: { only_integer: true, greater_than: 0 }
  validates :period_start, :period_end, :due_on, presence: true
  validate :tenant_consistency

  def terminal? = paid? || void?

  private

  def tenant_consistency
    return unless account
    errors.add(:subscription, "deve pertencer à mesma empresa") if subscription && subscription.account_id != account_id
    errors.add(:customer, "deve pertencer à mesma empresa") if customer && customer.account_id != account_id
  end
end
