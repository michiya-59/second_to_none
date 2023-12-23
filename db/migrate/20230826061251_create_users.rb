# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :login_id, null: false, limit: 64
      t.string :email, null: false, limit: 64
      t.string :name, null: false
      t.string :name_kana, null: false
      t.datetime :birthday, null: false
      t.string :phone, null: false
      t.string :password_digest, null: false
      t.integer :status, null: false
      t.integer :introducer_id, null: false
      t.integer :admin_flg, null: false
      t.datetime :last_login_at
      t.string :image
      t.integer :gender_id, null: false
      t.integer :online_flg, null: false
      t.references :grade, null: false, foreign_key: true
      t.timestamps
    end
    add_index :users, :login_id, unique: true
  end
end
