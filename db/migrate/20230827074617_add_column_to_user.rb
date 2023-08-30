# frozen_string_literal: true

class AddColumnToUser < ActiveRecord::Migration[7.0]
  change_table :users, bulk: true do |t|
    t.integer :failed_login_count, default: 0
    t.boolean :locked, default: false, null: false
  end
end
