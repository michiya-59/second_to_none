# frozen_string_literal: true

module LearnsHelper
  def video_viewed? _video_id, index
    return true if index < 3  # 最初の3つの動画は常に視聴可能

    required_views = @learn_infos[0..index - 1].pluck(:id)  # 視聴が必要な動画のIDリスト
    current_user.video_views.where(learn_id: required_views).count == required_views.count
  end
end
