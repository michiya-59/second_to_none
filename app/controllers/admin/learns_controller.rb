# frozen_string_literal: true

module Admin
  class LearnsController < ApplicationController
    before_action :set_learn_category_id, only: %i(index)
    before_action :load_learn_data, only: %i(index edit update)
    before_action :find_learn_data, only: %i(edit update destroy)

    def index
      @learn = Learn.new
      @search_year, @search_month = set_search_date params, session[:search_learn_year], session[:search_learn_month]
      @learn_category_name = LearnCategory.select(:name).find(session[:learn_category_id]).name
    end

    def edit; end

    def create
      # current_userのIDは自動的にセットされる
      @learn = current_user.learns.build(learn_params)
      @learn.learn_category_id = session[:learn_category_id] if session[:learn_category_id].present?

      # 特定のカテゴリーにおける現在の最大のorder_numを取得し、1を加える
      max_order_num = Learn.where(learn_category_id: @learn.learn_category_id).maximum(:order_num) || 0
      @learn.order_num = max_order_num + 1
      if @learn.save
        CompressVideoJob.perform_later(@learn.video_file.blob) if @learn.video_file.attached?
        flash[:success] = "学びの資料を登録しました。"
      else
        flash[:form_error] = @learn.errors.full_messages
      end

      if session[:admin_learn_page].present? && session[:search_learn_year].present? && session[:search_learn_month].present?
        redirect_to admin_learns_path(id: session[:learn_category_id], page: session[:admin_learn_page], search_month: session[:search_learn_month], search_year: session[:search_learn_year])
      else
        redirect_to admin_learns_path(id: session[:learn_category_id])
      end
    end

    def update
      # ファイルの削除
      @learn.document_file.purge if learn_params[:remove_document_file] == "1"
      @learn.video_file.purge if learn_params[:remove_video_file] == "1"

      if @learn.update(learn_params)
        flash[:success] = "学びのカテゴリーを編集しました。"
        if session[:admin_learn_page].present? && session[:search_learn_year].present? && session[:search_learn_month].present?
          redirect_to admin_learns_path(id: session[:learn_category_id], page: session[:admin_learn_page], search_month: session[:search_learn_month], search_year: session[:search_learn_year])
        else
          redirect_to admin_learns_path(id: session[:learn_category_id])
        end
      else
        render :edit
      end
    end

    def destroy
      @learn.destroy
      flash[:success] = "学びの資料を削除しました。"
      if session[:admin_learn_page].present? && session[:search_learn_year].present? && session[:search_learn_month].present?
        redirect_to admin_learns_path(id: session[:learn_category_id], page: session[:admin_learn_page], search_month: session[:search_learn_month], search_year: session[:search_learn_year])
      else
        redirect_to admin_learns_path(id: session[:learn_category_id])
      end
    end

    private

    def learn_params
      params.require(:learn).permit(:name, :document_file, :video_file, :learn_category_id, :user_id, :remove_document_file, :remove_video_file)
    end

    def set_learn_category_id
      return if params[:id].blank?

      session[:learn_category_id] = params[:id].to_i
    end

    def load_learn_data
      if params[:search_year].present? && params[:search_month].present?
        session[:admin_learn_page] = params[:page] if params[:page].present?
        session[:search_learn_year] = params[:search_year]
        session[:search_learn_month] = params[:search_month]

        # 開始日と終了日を取得
        start_date = if session[:search_learn_year].present? && session[:search_learn_month].present?
                       Date.new(session[:search_learn_year].to_i, session[:search_learn_month].to_i)
                     else
                       Date.new(params[:search_year].to_i, params[:search_month].to_i)
                     end
        end_date = start_date.end_of_month

        learn_query = Learn.where(created_at: start_date.beginning_of_month..end_date)
      else
        learn_query = Learn.created_this_month
      end

      if session[:learn_category_id].present?
        learn_query = learn_query.where(learn_category_id: session[:learn_category_id])
      end

      # Active Storageのattachmentsとblobsを事前にロード
      learn_query = learn_query.includes(
        {document_file_attachment: :blob, video_file_attachment: :blob},
        :learn_category
      )

      @learns = learn_query.order(created_at: :desc)
      @learn_infos = Kaminari.paginate_array(@learns).page(params[:page]).per(10)
    end

    def find_learn_data
      @learn = Learn.find(params[:id])
    end
  end
end
