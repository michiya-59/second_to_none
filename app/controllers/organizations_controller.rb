# frozen_string_literal: true

class OrganizationsController < ApplicationController
  def index
    @users = User.includes(:user_image_attachment, :grade).all
    gon.users = format_org_data(@users)
  end

  private

  def format_org_data users
    users.map do |user|
      # ユーザの画像があればそのURLを、なければデフォルト画像のURLを使用
      user_image_url = user.user_image.attached? ? url_for(user.user_image) : ActionController::Base.helpers.asset_path("default.png")
      parent_user = users.find { |u| u.id == user.introducer_id }
      parent_name = parent_user ? parent_user.name : "なし"

      {
        id: user.id,
        name: user.name,
        title: user.grade.grade_name, # または他の適切な属性
        pid: user.introducer_id,
        parent_name:, # 親ユーザの名前を追加
        img: user_image_url
      }
    end
  end
end
