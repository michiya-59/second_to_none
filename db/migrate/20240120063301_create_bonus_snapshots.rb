# frozen_string_literal: true

class CreateBonusSnapshots < ActiveRecord::Migration[7.0]
  def change
    create_table :bonus_snapshots do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :reward_snapshots_date
      t.integer :reward_bonus_total
      t.integer :two_tier_bonus_total
      t.integer :title_bonus_total
      t.integer :a_san_bonus_total
      t.integer :tax_withholding
      t.integer :administration_fee
      t.integer :cap_adjustment_money
      t.integer :total_price
      t.integer :total_payment_price

      t.timestamps
    end
  end
end
