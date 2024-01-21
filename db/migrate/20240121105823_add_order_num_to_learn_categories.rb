# frozen_string_literal: true

class AddOrderNumToLearnCategories < ActiveRecord::Migration[7.0]
  def change
    add_column :learn_categories, :order_num, :integer
  end
end
