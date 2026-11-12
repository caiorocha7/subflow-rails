# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_11_12_000000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.string "api_token_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_accounts_on_slug", unique: true
  end

  create_table "audit_events", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "user_id"
    t.string "action", null: false
    t.string "auditable_type", null: false
    t.bigint "auditable_id", null: false
    t.jsonb "metadata", default: {}, null: false
    t.string "correlation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "auditable_type", "auditable_id"], name: "idx_on_account_id_auditable_type_auditable_id_60ad08d10d"
    t.index ["account_id"], name: "index_audit_events_on_account_id"
    t.index ["user_id"], name: "index_audit_events_on_user_id"
  end

  create_table "customers", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "name", null: false
    t.string "email", null: false
    t.string "document"
    t.string "phone"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "email"], name: "index_customers_on_account_id_and_email", unique: true
    t.index ["account_id"], name: "index_customers_on_account_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "subscription_id", null: false
    t.bigint "customer_id", null: false
    t.integer "amount_cents", null: false
    t.string "currency", default: "BRL", null: false
    t.integer "status", default: 0, null: false
    t.date "period_start", null: false
    t.date "period_end", null: false
    t.date "due_on", null: false
    t.datetime "paid_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_invoices_on_account_id"
    t.index ["customer_id"], name: "index_invoices_on_customer_id"
    t.index ["subscription_id", "period_start"], name: "index_invoices_on_subscription_id_and_period_start", unique: true
    t.index ["subscription_id"], name: "index_invoices_on_subscription_id"
  end

  create_table "payment_events", force: :cascade do |t|
    t.bigint "account_id"
    t.bigint "invoice_id"
    t.string "event_id", null: false
    t.string "event_type", null: false
    t.datetime "occurred_at", null: false
    t.jsonb "payload", default: {}, null: false
    t.datetime "processed_at"
    t.string "processing_error"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_payment_events_on_account_id"
    t.index ["event_id"], name: "index_payment_events_on_event_id", unique: true
    t.index ["invoice_id"], name: "index_payment_events_on_invoice_id"
  end

  create_table "plans", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "name", null: false
    t.text "description"
    t.integer "amount_cents", null: false
    t.string "currency", default: "BRL", null: false
    t.integer "interval", default: 0, null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "name"], name: "index_plans_on_account_id_and_name", unique: true
    t.index ["account_id"], name: "index_plans_on_account_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "customer_id", null: false
    t.bigint "plan_id", null: false
    t.integer "status", default: 0, null: false
    t.date "starts_on", null: false
    t.date "next_billing_on", null: false
    t.datetime "canceled_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "customer_id", "plan_id", "status"], name: "idx_on_account_id_customer_id_plan_id_status_d2bcdfae7c"
    t.index ["account_id"], name: "index_subscriptions_on_account_id"
    t.index ["customer_id"], name: "index_subscriptions_on_customer_id"
    t.index ["plan_id"], name: "index_subscriptions_on_plan_id"
  end

  create_table "users", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "name", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.integer "role", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "email"], name: "index_users_on_account_id_and_email", unique: true
    t.index ["account_id"], name: "index_users_on_account_id"
  end

  add_foreign_key "audit_events", "accounts"
  add_foreign_key "audit_events", "users"
  add_foreign_key "customers", "accounts"
  add_foreign_key "invoices", "accounts"
  add_foreign_key "invoices", "customers"
  add_foreign_key "invoices", "subscriptions"
  add_foreign_key "payment_events", "accounts"
  add_foreign_key "payment_events", "invoices"
  add_foreign_key "plans", "accounts"
  add_foreign_key "subscriptions", "accounts"
  add_foreign_key "subscriptions", "customers"
  add_foreign_key "subscriptions", "plans"
  add_foreign_key "users", "accounts"
end
