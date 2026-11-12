class AuditLogger
  def self.log(account:, action:, record:, user: nil, metadata: {}, correlation_id: nil)
    AuditEvent.create!(account:, user:, action:, auditable_type: record.class.name,
      auditable_id: record.id, metadata:, correlation_id:)
  end
end
