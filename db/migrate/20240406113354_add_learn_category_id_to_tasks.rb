# frozen_string_literal: true

class AddLearnCategoryIdToTasks < ActiveRecord::Migration[7.0]
  def change
    add_reference :tasks, :learn_category, foreign_key: true
  end
end
