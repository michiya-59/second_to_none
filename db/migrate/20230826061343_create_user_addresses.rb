# frozen_string_literal: true

class CreateUserAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :user_addresses do |t|
      t.references :user, null: false, foreign_key: true, unique: true
      t.string :zip_str3, null: false
      t.string :zip_str4, null: false
      t.string :ken, null: false
      t.string :city, null: false
      t.string :other_address
      t.timestamps
    end
  end
end
