# frozen_string_literal: true

class CreateRewards < ActiveRecord::Migration[7.0]
  def change
    create_table :rewards do |t|
      t.integer :user_id, null: false, comment: "ユーザID"
      t.integer :incentive_id, null: false, comment: "報酬コード"
      t.integer :incentive_price, comment: "報酬金額"

      t.timestamps
    end

    add_foreign_key :rewards, :users, column: :user_id
    add_foreign_key :rewards, :incentives, column: :incentive_id
  end
end
