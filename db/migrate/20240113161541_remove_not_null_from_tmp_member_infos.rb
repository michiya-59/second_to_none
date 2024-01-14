class RemoveNotNullFromTmpMemberInfos < ActiveRecord::Migration[7.0]
  def change
    change_column_null :tmp_member_infos, :email, true
    change_column_null :tmp_member_infos, :name, true
    change_column_null :tmp_member_infos, :name_kana, true
    change_column_null :tmp_member_infos, :birthday, true
    change_column_null :tmp_member_infos, :phone, true
    change_column_null :tmp_member_infos, :login_id, true
    change_column_null :tmp_member_infos, :password_digest, true
    change_column_null :tmp_member_infos, :introducer_id, true
    change_column_null :tmp_member_infos, :gender_id, true
    change_column_null :tmp_member_infos, :zip_str3, true
    change_column_null :tmp_member_infos, :zip_str4, true
    change_column_null :tmp_member_infos, :ken, true
    change_column_null :tmp_member_infos, :city, true
    change_column_null :tmp_member_infos, :other_address, true
    change_column_null :tmp_member_infos, :account_type, true
    change_column_null :tmp_member_infos, :bank_name, true
    change_column_null :tmp_member_infos, :branch_name, true
    change_column_null :tmp_member_infos, :branch_number, true
    change_column_null :tmp_member_infos, :account_number_hash, true
    change_column_null :tmp_member_infos, :account_number_tail, true
    change_column_null :tmp_member_infos, :account_holder, true
    change_column_null :tmp_member_infos, :sales_id, true
    change_column_null :tmp_member_infos, :incentive_id, true
    change_column_null :tmp_member_infos, :a_san_flg, true
    change_column_null :tmp_member_infos, :approval_id, true
  end
end
