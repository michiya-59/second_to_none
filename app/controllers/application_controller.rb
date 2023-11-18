# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include(SessionsHelper)
  before_action :authenticate_user, :redirect_not_logged_in, :redirect_not_session, :set_session_expiration

  # ログインされていない場合またはURLが直接操作されてた場合の処理
  def authenticate_user
    return if logged_in? && valid_referrer?

    reset_session
    flash[:logout] = "不正なアクセスがありました。<br>再度ログインをしてください。"
    redirect_to login_path
  end

  # ログインされていない場合は、ログイン画面にリダイレクトさせる処理
  def redirect_not_logged_in
    return if current_user

    reset_session
    flash[:logout] = "ログインされてません。ログインしてください。"
    redirect_to login_path
  end

  # 60分でセッションが切れて、ログアウトする処理
  def redirect_not_session
    return unless session[:expires_at]

    # session[:expires_at] を Time オブジェクトとして読み込み
    expires_at = Time.zone.parse(session[:expires_at].to_s)
    # 現在の時間との差を比較
    session_out_time = Time.zone.now - expires_at

    return unless session_out_time > 0

    reset_session
    flash[:logout] = "セッションが切れました<br>（60分間ご利用でない場合、または不正アクセスのため）"
    redirect_to login_path
  end

  # 操作時間の60set_search_date分前の時間を格納
  def set_session_expiration
    session[:expires_at] = 60.minutes.from_now
  end

  # URLが直接操作されているかどうかの確認
  def valid_referrer?
    request.referer.present? && request.referer.include?(request.base_url)
  end

  # 管理項目 リストの検索処理
  def set_search_date params, search_seminars_year, search_seminars_month
    if search_seminars_year.present? && search_seminars_month.present?
      search_year = search_seminars_year
      search_month = search_seminars_month
    elsif params[:search_year].present?
      search_year = params[:search_year]
      search_month = params[:search_month]
    else
      search_year = Time.zone.today.year
      search_month = Time.zone.today.month
    end
    [search_year, search_month]
  end
end
