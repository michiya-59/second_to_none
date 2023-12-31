# frozen_string_literal: true

class CreateUserAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :user_addresses do |t|
      t.references :user, null: false, foreign_key: true, unique: true
      t.integer :zip_str3, null: false
      t.integer :zip_str4, null: false
      t.string :ken, null: false
      t.string :city, null: false
      t.string :other_address
      t.timestamps
    end
  end
end
