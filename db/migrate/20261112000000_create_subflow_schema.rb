class CreateSubflowSchema < ActiveRecord::Migration[8.1]
  def change
    create_table :accounts do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.string :api_token_digest
      t.timestamps
    end
    add_index :accounts, :slug, unique: true

    create_table :users do |t|
      t.references :account, null: false, foreign_key: true
      t.string :name, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.integer :role, null: false, default: 0
      t.timestamps
    end
    add_index :users, %i[account_id email], unique: true

    create_table :customers do |t|
      t.references :account, null: false, foreign_key: true
      t.string :name, null: false
      t.string :email, null: false
      t.string :document
      t.string :phone
      t.integer :status, null: false, default: 0
      t.timestamps
    end
    add_index :customers, %i[account_id email], unique: true

    create_table :plans do |t|
      t.references :account, null: false, foreign_key: true
      t.string :name, null: false
      t.text :description
      t.integer :amount_cents, null: false
      t.string :currency, null: false, default: "BRL"
      t.integer :interval, null: false, default: 0
      t.boolean :active, null: false, default: true
      t.timestamps
    end
    add_index :plans, %i[account_id name], unique: true

    create_table :subscriptions do |t|
      t.references :account, null: false, foreign_key: true
      t.references :customer, null: false, foreign_key: true
      t.references :plan, null: false, foreign_key: true
      t.integer :status, null: false, default: 0
      t.date :starts_on, null: false
      t.date :next_billing_on, null: false
      t.datetime :canceled_at
      t.timestamps
    end
    add_index :subscriptions, %i[account_id customer_id plan_id status]

    create_table :invoices do |t|
      t.references :account, null: false, foreign_key: true
      t.references :subscription, null: false, foreign_key: true
      t.references :customer, null: false, foreign_key: true
      t.integer :amount_cents, null: false
      t.string :currency, null: false, default: "BRL"
      t.integer :status, null: false, default: 0
      t.date :period_start, null: false
      t.date :period_end, null: false
      t.date :due_on, null: false
      t.datetime :paid_at
      t.timestamps
    end
    add_index :invoices, %i[subscription_id period_start], unique: true

    create_table :payment_events do |t|
      t.references :account, foreign_key: true
      t.references :invoice, foreign_key: true
      t.string :event_id, null: false
      t.string :event_type, null: false
      t.datetime :occurred_at, null: false
      t.jsonb :payload, null: false, default: {}
      t.datetime :processed_at
      t.string :processing_error
      t.timestamps
    end
    add_index :payment_events, :event_id, unique: true

    create_table :audit_events do |t|
      t.references :account, null: false, foreign_key: true
      t.references :user, foreign_key: true
      t.string :action, null: false
      t.string :auditable_type, null: false
      t.bigint :auditable_id, null: false
      t.jsonb :metadata, null: false, default: {}
      t.string :correlation_id
      t.timestamps
    end
    add_index :audit_events, %i[account_id auditable_type auditable_id]
  end
end
