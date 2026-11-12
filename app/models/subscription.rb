class Subscription < ApplicationRecord
  belongs_to :account
  belongs_to :customer
  belongs_to :plan
  has_many :invoices, dependent: :restrict_with_exception
  enum :status, { trialing: 0, active: 1, past_due: 2, canceled: 3 }
  validates :starts_on, :next_billing_on, presence: true
  validate :tenant_consistency

  def billable?
    active? || trialing? || past_due?
  end

  def billing_period
    plan.yearly? ? 1.year : 1.month
  end

  private

  def tenant_consistency
    return unless account && (customer || plan)
    errors.add(:customer, "deve pertencer à mesma empresa") if customer && customer.account_id != account_id
    errors.add(:plan, "deve pertencer à mesma empresa") if plan && plan.account_id != account_id
  end
end
