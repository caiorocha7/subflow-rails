class Plan < ApplicationRecord
  belongs_to :account
  has_many :subscriptions, dependent: :restrict_with_error
  enum :interval, { monthly: 0, yearly: 1 }
  validates :name, presence: true, uniqueness: { scope: :account_id }
  validates :amount_cents, numericality: { only_integer: true, greater_than: 0 }
  validates :currency, inclusion: { in: ["BRL"] }

  def monthly_amount_cents
    yearly? ? (amount_cents / 12.0).round : amount_cents
  end
end
