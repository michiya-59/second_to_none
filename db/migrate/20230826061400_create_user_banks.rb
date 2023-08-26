# frozen_string_literal: true

class CreateUserBanks < ActiveRecord::Migration[7.0]
  def change
    create_table :user_banks do |t|
      t.references :user, null: false, foreign_key: true, unique: true
      t.string :account_type, null: false
      t.string :bank_name, null: false
      t.string :branch_name, null: false
      t.string :branch_number, null: false
      t.string :account_number_hash, null: false
      t.string :account_number_tail, null: false
      t.string :account_holder, null: false
      t.timestamps
    end
  end
end
