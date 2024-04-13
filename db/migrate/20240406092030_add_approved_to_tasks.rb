# frozen_string_literal: true

class AddApprovedToTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :approved, :boolean, default: false, null: false
  end
end
