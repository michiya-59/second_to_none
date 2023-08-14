module TmpMemberInfosHelper
  def prev_step_path
    session[:current_step] -= 1
    new_tmp_member_info_path
  end

  def get_default_value(column_name, input_type = "text")
    if input_type == "text" || input_type == "textarea"
      default_value = session[:tmp_member_info_data] && session[:tmp_member_info_data][column_name] || "" 
      return default_value
    elsif input_type == "select" || input_type == "radio"      
      default_value = session[:tmp_member_info_data] && session[:tmp_member_info_data][column_name] || 1
      return default_value.to_i
    end
  end

  def get_default_birthday_value
    birthday_value = {}
    birthday_value[:year] = session[:tmp_member_info_data] && session[:tmp_member_info_data]["birthday(1i)"] || nil
    birthday_value[:month] = session[:tmp_member_info_data] && session[:tmp_member_info_data]["birthday(2i)"] || nil
    birthday_value[:day] = session[:tmp_member_info_data] && session[:tmp_member_info_data]["birthday(3i)"] || nil
  
    # 年、月、日のいずれかがnilでないことを確認
    if birthday_value[:year] && birthday_value[:month] && birthday_value[:day]
      return Date.new(birthday_value[:year].to_i, birthday_value[:month].to_i, birthday_value[:day].to_i)
    else
      return Date.new(1990, 1, 1)
    end
  end
  
end