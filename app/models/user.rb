class User < ApplicationRecord
  belongs_to :account
  has_secure_password
  enum :role, { member: 0, admin: 1 }
  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: { scope: :account_id }
end
