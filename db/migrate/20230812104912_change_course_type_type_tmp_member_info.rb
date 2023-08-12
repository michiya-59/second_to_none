class ChangeCourseTypeTypeTmpMemberInfo < ActiveRecord::Migration[6.1]
  def change
    rename_column :tmp_member_infos, :course_type, :incentive_id
    change_column :tmp_member_infos, :incentive_id, 'integer USING incentive_id::integer'
  end
end
