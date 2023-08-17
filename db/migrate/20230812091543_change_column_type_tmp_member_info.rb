# frozen_string_literal: true

class ChangeColumnTypeTmpMemberInfo < ActiveRecord::Migration[6.1]
  def change
    change_column :tmp_member_infos, :other_address, :string
    change_column :tmp_member_infos, :zip_str3, :string
    change_column :tmp_member_infos, :zip_str4, :string
  end
end
