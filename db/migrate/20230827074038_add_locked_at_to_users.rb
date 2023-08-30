# frozen_string_literal: true

class AddLockedAtToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :locked_at, :datetime
  end
end
