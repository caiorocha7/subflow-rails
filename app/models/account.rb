class Account < ApplicationRecord
  has_many :users, dependent: :restrict_with_exception
  has_many :customers, dependent: :restrict_with_exception
  has_many :plans, dependent: :restrict_with_exception
  has_many :subscriptions, dependent: :restrict_with_exception
  has_many :invoices, dependent: :restrict_with_exception
  has_many :audit_events, dependent: :restrict_with_exception

  validates :name, presence: true, length: { maximum: 100 }
  validates :slug, presence: true, uniqueness: true, format: { with: /\A[a-z0-9-]+\z/ }

  def mrr_cents
    subscriptions.active.includes(:plan).sum { |subscription| subscription.plan.monthly_amount_cents }
  end

  def issue_api_token!
    token = SecureRandom.hex(32)
    update!(api_token_digest: BCrypt::Password.create(token))
    token
  end

  def authenticate_api_token(token)
    api_token_digest.present? && BCrypt::Password.new(api_token_digest).is_password?(token)
  rescue BCrypt::Errors::InvalidHash
    false
  end
end
