class RemoveUserIdFromTmpMemberInfo < ActiveRecord::Migration[6.1]
  def change
    remove_column :tmp_member_infos, :user_id, :integer
  end
end
