# frozen_string_literal: true

module LearnsHelper
  # def video_viewed? _video_id, index
  #   return true if index < 3  # 最初の3つの動画は常に視聴可能

  #   required_views = @learn_infos[0..index - 1].pluck(:id)  # 視聴が必要な動画のIDリスト
  #   current_user.video_views.where(learn_id: required_views).count == required_views.count
  # end

  def task_submitted? learn_id, user_id, index
    # 最初の3つの資料には制限をかけない
    if params[:page].present? && params[:page].to_i >= 2
    elsif index <= 3
      return true
    end

    # 4つ目以降の資料については、それまでの全ての資料の課題が提出されているかを確認
    # そのために、現在のlearn_idより小さい全てのlearn_idを取得
    previous_learn_ids = Learn.where("id < ? AND learn_category_id = ?", learn_id, 1).pluck(:id)

    # それらのlearn_idに対して、全ての課題が提出されているかを確認
    previous_learn_ids.all?{|id| Task.exists?(learn_id: id, user_id:)}
  end
end
