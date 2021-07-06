# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

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

ActiveRecord::Schema.define(version: 20_210_706_113_406) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'reports', force: :cascade do |t|
    t.string 'type', null: false
    t.integer 'author_id', null: false
    t.jsonb 'form', default: {}, null: false
    t.jsonb 'results', default: {}, null: false
    t.string 'status', default: 'pending', null: false
    t.datetime 'processed_at'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.integer 'member_id'
    t.string 'file'
    t.string 'error_message'
  end

  create_table 'service_invoices', force: :cascade do |t|
    t.integer 'wallet_id', null: false
    t.decimal 'amount', null: false
    t.string 'currency', null: false
    t.datetime 'completed_at'
    t.datetime 'invoice_created_at', null: false
    t.datetime 'expiry_at', null: false
    t.integer 'invoice_id', null: false
    t.string 'comment', null: false
    t.string 'status', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index %w[wallet_id invoice_id], name: 'index_service_invoices_on_wallet_id_and_invoice_id', unique: true
  end

  create_table 'service_withdraws', force: :cascade do |t|
    t.integer 'wallet_id', null: false
    t.string 'public_name', null: false
    t.decimal 'amount', null: false
    t.string 'currency', null: false
    t.string 'withdraw_type', null: false
    t.string 'status', null: false
    t.datetime 'date', null: false
    t.integer 'withdraw_id'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index %w[wallet_id withdraw_id], name: 'index_service_withdraws_on_wallet_id_and_withdraw_id', unique: true
  end
end
