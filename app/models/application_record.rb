class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  scope :for_account, ->(account) { where(account:) }
end
