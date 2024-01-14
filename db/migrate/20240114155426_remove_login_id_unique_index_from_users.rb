# frozen_string_literal: true

class RemoveLoginIdUniqueIndexFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_index :tmp_member_infos, :login_id
  end
end
