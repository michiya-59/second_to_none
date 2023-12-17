# frozen_string_literal: true

module Admin
  class CapAdjustMentsController < ApplicationController
    before_action :load_cap_adjustments_data, only: %i(index edit)
    def index
      @user_all = User.select(:id, :name).all
    end

    def edit
      return if params[:id].blank?

      @cap_adjustment_money = CapAdjustmentMoney.find_or_initialize_by(user_id: params[:id])
      
    end

    def create
      @cap_adjustment_money = CapAdjustmentMoney.new(cap_adjustment_money_params)
      if @cap_adjustment_money.save
        flash[:success] = "キャップ調整金を変更しました。"
        redirect_to admin_cap_adjust_ments_path
      else
        render :index
      end
    end

    def update
      cap_adjustment_money = CapAdjustmentMoney.find_by(user_id: params[:cap_adjustment_money][:user_id].to_i)

      if cap_adjustment_money.update(cap_adjustment_money_params)
        flash[:success] = "キャップ調整金を変更しました。"
        redirect_to admin_cap_adjust_ments_path
      else
        render :index
      end
    end

    private

    def load_cap_adjustments_data
      if params[:id].present?
        session[:cap_adjustment_user_id] = params[:id].to_i
        @user = User.select("users.id, users.name, COALESCE(cap_adjustment_moneys.price, 0) as price").left_outer_joins(:cap_adjustment_money).find(session[:cap_adjustment_user_id])
      else
        @users = User.select("users.id, users.name, COALESCE(cap_adjustment_moneys.price, 0) as price").left_outer_joins(:cap_adjustment_money)
      end
    end

    def cap_adjustment_money_params
      params.require(:cap_adjustment_money).permit(:user_id, :price)
    end
  end
end
