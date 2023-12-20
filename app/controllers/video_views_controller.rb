class VideoViewsController < ApplicationController
  def create
    video_view = VideoView.find_or_initialize_by(video_view_params)

    if video_view.new_record? && video_view.save
      head :ok
    else
      head :unprocessable_entity
    end
  end

  private

  def video_view_params
    params.require(:video_view).permit(:learn_id, :user_id)
  end
end
