# frozen_string_literal: true

module TmpMemberInfosHelper
  def get_default_value(column_name, input_type = "text")
    if %w[text textarea].include?(input_type)
      (session[:tmp_member_info_data] && session[:tmp_member_info_data][column_name]) || ""

    elsif %w[select radio].include?(input_type)
      default_value = (session[:tmp_member_info_data] && session[:tmp_member_info_data][column_name]) || 1
      default_value.to_i
    end
  end

  def get_default_birthday_value
    birthday_value = {}
    birthday_value[:year] = (session[:tmp_member_info_data] && session[:tmp_member_info_data]["birthday(1i)"]) || nil
    birthday_value[:month] = (session[:tmp_member_info_data] && session[:tmp_member_info_data]["birthday(2i)"]) || nil
    birthday_value[:day] = (session[:tmp_member_info_data] && session[:tmp_member_info_data]["birthday(3i)"]) || nil

    # 年、月、日のいずれかがnilでないことを確認
    if birthday_value[:year] && birthday_value[:month] && birthday_value[:day]
      return Date.new(birthday_value[:year].to_i, birthday_value[:month].to_i, birthday_value[:day].to_i)
    end

    Date.new(1990, 1, 1)
  end
end
