# frozen_string_literal: true

class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.references :learn, null: false, foreign_key: true
      t.text :comment

      t.timestamps
    end
  end
end
