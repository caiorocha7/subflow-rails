class Customer < ApplicationRecord
  belongs_to :account
  has_many :subscriptions, dependent: :restrict_with_error
  has_many :invoices, dependent: :restrict_with_error
  enum :status, { active: 0, inactive: 1 }
  validates :name, :email, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: { scope: :account_id }
end
