# frozen_string_literal: true

class CreateCapAdjustmentMoneys < ActiveRecord::Migration[7.0]
  def change
    create_table :cap_adjustment_moneys do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :price, null: false

      t.timestamps
    end
  end
end
