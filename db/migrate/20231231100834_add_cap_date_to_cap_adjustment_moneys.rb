# frozen_string_literal: true

class AddCapDateToCapAdjustmentMoneys < ActiveRecord::Migration[7.0]
  def change
    add_column :cap_adjustment_moneys, :cap_date, :timestamp
  end
end
