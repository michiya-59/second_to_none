# frozen_string_literal: true

module ApprovalsHelper
  require "date"

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
