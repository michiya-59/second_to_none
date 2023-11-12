# frozen_string_literal: true

module Admin
  class PostsController < ApplicationController
    before_action :posts_load_data, only: %i(index new edit update)
    def index
      @search_year, @search_month = set_search_date params
    end

    def new
      @post = Post.new
    end

    def edit
      @post = Post.find(params[:id])
    end

    def create
      @post = Post.new(post_params)
      if @post.save
        flash[:success] = "お知らせ・イベント情報を追加しました。"
        redirect_to admin_posts_path
      else
        render :new
      end
    end

    def update
      @post = Post.find(params[:id])
      @post.assign_attributes(post_params)

      if @post.valid?
        @post.remove_event_image = params[:post][:remove_event_image] == "1"
        @post.save
        flash[:success] = "お知らせ・イベント情報を更新しました。"
        if session[:admin_post_page].present? && session[:search_post_year] && session[:search_post_month]
          redirect_to admin_posts_path(page: session[:admin_post_page], search_month: session[:search_post_month], search_year: session[:search_post_year])
        else
          redirect_to admin_posts_path
        end
      else
        render :edit
      end
    end

    def destroy
      @post = Post.find(params[:id])
      @post.destroy
      flash[:success] = "お知らせ・イベントを削除しました。"
      if session[:admin_post_page].present? && session[:search_post_year] && session[:search_post_month]
        redirect_to admin_posts_path(page: session[:admin_post_page], search_month: session[:search_post_month], search_year: session[:search_post_year])
      else
        redirect_to admin_posts_path
      end
    end

    private

    def posts_load_data
      if params[:search_year].present? && params[:search_month].present?
        session[:admin_post_page] = params[:page] if params[:page].present?
        session[:search_post_year] = params[:search_year]
        session[:search_post_month] = params[:search_month]
        # 開始日と終了日を取得
        start_date = if session[:search_post_year].present? && session[:search_post_month].present?
                       Date.new(session[:search_post_year].to_i, session[:search_post_month].to_i)
                     else
                       Date.new(params[:search_year].to_i, params[:search_month].to_i)
                     end
        end_date = start_date.end_of_month

        # created_at列で範囲検索を行う
        @posts = Post.where(created_at: start_date.beginning_of_month..end_date)
      else
        @posts = Post.created_this_month
      end
      @post_infos = Kaminari.paginate_array(@posts).page(params[:page]).per(10)
      @post_infos
    end

    def post_params
      params.require(:post).permit(:title, :body, :category_flg, :event_image)
    end
  end
end
