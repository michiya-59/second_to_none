# frozen_string_literal: true

class AddIncentiveIdToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :incentive_id, :integer
  end
end
