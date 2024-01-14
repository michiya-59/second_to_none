# frozen_string_literal: true

module TmpMemberInfosHelper
  def get_default_value column_name, input_type, tmp_member_info
    if %w(text textarea).include?(input_type)
      tmp_member_info&.send(column_name) || ""
    elsif %w(select radio).include?(input_type)
      tmp_member_info&.send(column_name).to_i || 1
    end
  end

  def get_default_birthday_value tmp_member_info
    return tmp_member_info.birthday.to_date if tmp_member_info.birthday

    Date.new(1990, 1, 1)
  end
end
