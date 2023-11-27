# frozen_string_literal: true

module ApplicationHelper
  require "date"

  def get_current_path
    request.fullpath
  end

  def page_year_month_include? page, year, month
    if page.present? && year && month
      true
    else
      false
    end
  end

  # 誕生日から年齢を取得
  def calculate_age birthdate
    # 現在の日付を取得
    today = Time.zone.today
    
    # 現在の年 - 生年月日の年
    age = today.year - birthdate.year

    # 今年の誕生日をまだ迎えていなければ、年齢から1を引く
    age -= 1 if today < birthdate + age.years

    age
  end
end
