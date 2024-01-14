# frozen_string_literal: true

class RemoveEmailIndexFromTmpMemberInfos < ActiveRecord::Migration[7.0]
  def change
    remove_index :tmp_member_infos, :email
  end
end
