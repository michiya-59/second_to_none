# frozen_string_literal: true

class ApprovalsController < ApplicationController
  before_action :approval_load_data, only: %i(index)
  def index
    @search_year, @search_month = set_search_date params, session[:search_post_year], session[:search_post_month]
  end

  def edit
    @approval = TmpMemberInfo.find(params[:id])
    @type = params[:type]
  end

  # 承認確定ボタンを押した際の処理
  def update
    approval = TmpMemberInfo.find(params[:id])

    if approval.present?
      ActiveRecord::Base.transaction do
        # ユーザ情報の登録
        user = User.create_user approval
        # ユーザ住所情報の登録
        UserAddress.create_user_address user, approval
        # ユーザ銀行情報の登録
        UserBank.create_user_bank user, approval
        # 関係情報の登録
        Relationship.create_relationship user
        # 報酬ボーナスの登録
        Reward.create_rewards user, approval
        # グレード更新処理
        UserIntroducerGradeUpdater.new(user).update_introducer_grades

        # 承認済みに変更
        approval.update(approval_id: 1)
      end
    end
    flash[:success] = "本登録完了しました。"
    if session[:search_approval_year].present? && session[:search_approval_month].present?
      redirect_to approvals_path(search_year: session[:search_approval_year], search_month: session[:search_approval_month], type: "new")
    else
      redirect_to approvals_path(type: "new")
    end
  end

  private

  def approval_load_data
    if params[:search_year].present? && params[:search_month].present?
      session[:approval_page] = params[:page] if params[:page].present?
      session[:search_approval_year] = params[:search_year]
      session[:search_approval_month] = params[:search_month]
      # 開始日と終了日を取得
      start_date = if session[:search_approval_year].present? && session[:search_approval_month].present?
                     Date.new(session[:search_approval_year].to_i, session[:search_approval_month].to_i)
                   else
                     Date.new(params[:search_year].to_i, params[:search_month].to_i)
                   end
      end_date = start_date.end_of_month

      if params[:type] == "new"
        # created_at列で範囲検索を行う
        @type = "new"
        @approval = TmpMemberInfo.includes(:introducer, :sales)
          .where(created_at: start_date.beginning_of_month..end_date, approval_id: 2)
          .order(created_at: :desc)
      elsif params[:type] == "done"
        # created_at列で範囲検索を行う
        @type = "done"
        @approval = TmpMemberInfo.includes(:introducer, :sales)
          .where(created_at: start_date.beginning_of_month..end_date, approval_id: 1)
          .order(created_at: :desc)
      end
    elsif params[:type] == "new"
      @type = "new"
      @approval = TmpMemberInfo.includes(:introducer, :sales)
        .created_this_month
        .where(approval_id: 2)
        .order(created_at: :desc)
    # created_at列で範囲検索を行う
    elsif params[:type] == "done"
      # created_at列で範囲検索を行う
      @type = "done"
      @approval = TmpMemberInfo.includes(:introducer, :sales)
        .created_this_month
        .where(approval_id: 1)
        .order(created_at: :desc)
    end

    @approval_lists = Kaminari.paginate_array(@approval).page(params[:page]).per(15)
    @approval_lists
  end
end
