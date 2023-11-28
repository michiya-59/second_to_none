# frozen_string_literal: true

class TitlesController < ApplicationController
  def index
    @user = User.find(current_user.id)
    @first_level_count, @second_level_count = get_introduce_count @user.id
    @next_grade, @needed_first_level, @needed_second_level = calculate_needed_for_next_grade @first_level_count, @second_level_count
  end

  private

  def get_introduce_count user_id
    return unless user_id

    # 1段目の紹介人数取得
    introducer_datas = Relationship.where(parent_id: user_id)
    introducer_introduction_count = count_second_level_introductions introducer_datas
    [introducer_datas.count, introducer_introduction_count]
  end

  def count_second_level_introductions introducer_datas
    introducer_datas.sum do |introducer_data|
      Relationship.where(parent_id: introducer_data&.child_id).count
    end
  end

  def calculate_needed_for_next_grade first_level, second_level
    if first_level < 3
      # エグゼクティブの条件
      ["エグゼクティブ", 3 - first_level, 0]
    elsif first_level >= 6 && second_level < 4
      # ルビーエグゼクティブの条件（1段目は6名以上、2段目は4名未満）
      ["ルビーエグゼクティブ", 0, 4 - second_level]
    elsif (first_level >= 6 && second_level >= 4) || (first_level >= 3 && second_level >= 12)
      # サファイヤエグゼクティブの条件（1段目と2段目がそれぞれ12名以上、またはルビーエグゼクティブを満たしている）
      ["サファイヤエグゼクティブ", 12 - first_level, 12 - second_level]
    elsif first_level >= 3
      # エグゼクティブを超えているが、ルビーエグゼクティブには達していない場合
      ["ルビーエグゼクティブ", 6 - first_level, 4 - [second_level, 4].min]
    else
      # 最上位グレード
      ["最上位グレード", 0, 0]
    end
  end  
end
