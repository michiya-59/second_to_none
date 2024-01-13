# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :authenticate_user, :redirect_not_logged_in, :redirect_not_session, only: %i(new create)

  def new; end

  def create
    login_validate_params

    user = User.find_by(login_id: params[:login_id])
    if user
      account_unlocked user
      if user.locked
        @lock = true
        @error_msg = "アカウントがロックされています"
        render :new
      elsif user.authenticate(params[:password])
        failed_info_reset user
        login(user)
        redirect_to root_path
      else
        user.failed_login_count += 1
        user = account_lock user
        user.save
        @error_msg = "ログインIDまたはパスワードが間違っています。<br>5回ログインに失敗すると、アカウントがロックされますのでご注意下さい。"
        render :new
      end
    else
      @error_msg = "入力に誤りがあります。ID・パスワードを再度ご確認ください。"
      render :new
    end
  end

  def destroy
    logout if logged_in?
    flash[:logout] = "ログアウトしました"
    redirect_to login_path
  end

  private

  def account_unlocked user
    return unless user.locked_at && (Time.zone.now - user.locked_at) > 30.seconds

    user.update(locked: false, locked_at: nil, failed_login_count: 0)
  end

  def account_lock user
    if user.failed_login_count > 4
      user.locked = true
      user.failed_login_count = 0
      user.locked_at = Time.zone.now
    end
    user
  end

  def failed_info_reset user
    user.update(locked: false, locked_at: nil, failed_login_count: 0)
  end

  def login_validate_params
    return if params[:login_id].present? && params[:password].present?

    if params[:login_id].blank? && params[:password].blank?
      @id_error_msg = "ログインIDを入力してください。"
      @pass_error_msg = "パスワードを入力してください。"
      render :new and return
    elsif params[:login_id].blank?
      @id_error_msg = "ログインIDを入力してください。"
      render :new and return
    elsif params[:password].blank?
      @pass_error_msg = "パスワードを入力してください。"
      render :new and return
    end
  end
end
