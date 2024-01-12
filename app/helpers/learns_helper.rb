# frozen_string_literal: true

module LearnsHelper
  # def video_viewed? _video_id, index
  #   return true if index < 3  # 最初の3つの動画は常に視聴可能

  #   required_views = @learn_infos[0..index - 1].pluck(:id)  # 視聴が必要な動画のIDリスト
  #   current_user.video_views.where(learn_id: required_views).count == required_views.count
  # end

  def task_submitted? learn_id, user_id
    # 最初の3つの資料には制限をかけない
    return true if learn_id <= 3

    # 4つ目以降の学びの資料については、前の学びの資料の課題が提出されているかを確認
    (1..learn_id - 1).all?{|id| Task.exists?(learn_id: id, user_id:)}
  end
end
