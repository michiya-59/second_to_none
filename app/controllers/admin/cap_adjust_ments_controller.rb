# frozen_string_literal: true

module Admin
  class CapAdjustMentsController < ApplicationController
    before_action :load_cap_adjustments_data, only: %i(index edit)
    def index
      @user_all = User.select(:id, :name).all
    end

    def edit
      return if params[:id].blank?

      @cap_adjustment_money = CapAdjustmentMoney.find_or_initialize_by(user_id: params[:id], cap_date: DateTime.new(@search_year, @search_month))
    end

    def create
      cap_adjustment_money = CapAdjustmentMoney.new(cap_adjustment_money_params)
      if cap_adjustment_money.save
        flash[:success] = "キャップ調整金を変更しました。"
        redirect_to edit_admin_cap_adjust_ment_path(cap_adjustment_money&.user_id)
      else
        render :index
      end
    end

    def update
      cap_adjustment_money = CapAdjustmentMoney.find_by(user_id: params[:cap_adjustment_money][:user_id].to_i, cap_date: params[:cap_adjustment_money][:cap_date])

      if cap_adjustment_money.update(cap_adjustment_money_params)
        flash[:success] = "キャップ調整金を変更しました。"
        redirect_to edit_admin_cap_adjust_ment_path(params[:cap_adjustment_money][:user_id])
      else
        render :index
      end
    end

    def cap_adjust_ments_search
      session[:search_cap_adjust_ment_year] = params[:search_year] if params[:search_year].present?
      if params[:search_month].present?
        session[:search_cap_adjust_ment_month] = params[:search_month]
      end
      redirect_to edit_admin_cap_adjust_ment_path(params[:id])
    end

    private

    def load_cap_adjustments_data
      if params[:id].present?
        @user = User.select("users.id, users.name").find(params[:id])
      else
        @user_all = User.select(:id, :name).all
      end

      @search_year = if session[:search_cap_adjust_ment_year].present?
                       session[:search_cap_adjust_ment_year].to_i
                     else
                       Time.zone.today.year
                     end

      @search_month = if session[:search_cap_adjust_ment_month].present?
                        session[:search_cap_adjust_ment_month].to_i
                      else
                        Time.zone.today.month
                      end
    end

    def cap_adjustment_money_params
      params.require(:cap_adjustment_money).permit(:user_id, :price, :cap_date)
    end
  end
end
