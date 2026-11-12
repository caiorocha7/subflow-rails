class AuditEvent < ApplicationRecord
  belongs_to :account
  belongs_to :user, optional: true
  validates :action, :auditable_type, :auditable_id, presence: true
end
