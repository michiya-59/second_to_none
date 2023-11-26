# frozen_string_literal: true

class CreateRelationships < ActiveRecord::Migration[7.0]
  def change
    create_table :relationships do |t|
      t.integer :parent_id, null: false
      t.integer :child_id, null: false
      t.string :position

      t.timestamps
    end

    # 外部キー制約を追加
    add_foreign_key :relationships, :users, column: :parent_id
    add_foreign_key :relationships, :users, column: :child_id

    # インデックスを追加
    add_index :relationships, :parent_id
    add_index :relationships, :child_id
  end
end
