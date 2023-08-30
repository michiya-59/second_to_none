class CreateLearns < ActiveRecord::Migration[7.0]
  def change
    create_table :learns do |t|
      t.string :name, null: false
      t.integer :learn_category_id, null: false
      t.integer :user_id, null: false

      t.timestamps
    end

    add_foreign_key :learns, :learn_categories
    add_foreign_key :learns, :users

    add_index :learns, :learn_category_id
    add_index :learns, :user_id
  end
end
