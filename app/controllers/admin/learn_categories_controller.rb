# frozen_string_literal: true

module Admin
  class LearnCategoriesController < ApplicationController
    before_action :set_learn_category, only: %i(edit update destroy)

    def index
      @learn_category = LearnCategory.new
      @learn_categories = LearnCategory.all
      session[:admin_learn_page] = nil
      session[:search_learn_year] = nil
      session[:search_learn_month] = nil
    end

    def edit; end
    def create
      @learn_category = LearnCategory.new(learn_category_params)

      # 現在の最大の order_num を取得し、1 を加える
      max_order_num = LearnCategory.maximum(:order_num) || 0
      @learn_category.order_num = max_order_num + 1
      if @learn_category.save
        flash[:success] = "学びのカテゴリーを登録しました。"
      else
        flash[:form_error] = @learn_category.errors.full_messages
      end
      redirect_to admin_learn_categories_path
    end

    def update
      if @learn_category.update(learn_category_params)
        flash[:success] = "学びのカテゴリーを登録しました。"
        redirect_to admin_learn_categories_path
      else
        render :edit
      end
    end

    def destroy
      @learn_category.destroy
      flash[:success] = "学びのカテゴリーを削除しました。"
      redirect_to admin_learn_categories_path
    end

    private

    def learn_category_params
      params.require(:learn_category).permit(:name)
    end

    def set_learn_category
      @learn_category = LearnCategory.find(params[:id])
    end
  end
end
