# frozen_string_literal: true

class RewardsController < ApplicationController
  before_action :reward_load_data
  before_action :set_date

  def index
    totle_payment_price = get_totle_payment_price
    @certificate_of_tax_deducted_price, fee_price = calculate_y(totle_payment_price)
    @cap_adjustment_money = CapAdjustmentMoney.find_by(user_id: current_user.id)&.price
    @total_payment_price = totle_payment_price - @certificate_of_tax_deducted_price - fee_price - @cap_adjustment_money.to_i
  end

  private

  def reward_load_data
    session[:search_rewards_year] = params[:search_year] if params[:search_year].present?
    session[:search_rewards_month] = params[:search_month] if params[:search_month].present?
  end

  def get_totle_payment_price
    reward_bonus_incentive_ids = [1, 2]
    two_tier_bonus_incentive_ids = [3, 4]
    a_san_bonus_incentive_ids = [5, 6]
    title_bonus_incentive_ids = [7, 8]

    if session[:search_rewards_year].present? && session[:search_rewards_month].present?
      @reward_bonus_total = calculate_monthly_user_rewards(current_user.id, *reward_bonus_incentive_ids, session[:search_rewards_year].to_i, session[:search_rewards_month].to_i)
      @two_tier_bonus_total = calculate_monthly_user_rewards(current_user.id, *two_tier_bonus_incentive_ids, session[:search_rewards_year].to_i, session[:search_rewards_month].to_i)
      @a_san_bonus_total = calculate_monthly_user_rewards(current_user.id, *a_san_bonus_incentive_ids, session[:search_rewards_year].to_i, session[:search_rewards_month].to_i)
      @title_bonus_total = calculate_monthly_user_rewards(current_user.id, *title_bonus_incentive_ids, session[:search_rewards_year].to_i, session[:search_rewards_month].to_i)
    else
      @reward_bonus_total = calculate_monthly_user_rewards(current_user.id, *reward_bonus_incentive_ids, nil, nil)
      @two_tier_bonus_total = calculate_monthly_user_rewards(current_user.id, *two_tier_bonus_incentive_ids, nil, nil)
      @a_san_bonus_total = calculate_monthly_user_rewards(current_user.id, *a_san_bonus_incentive_ids, nil, nil)
      @title_bonus_total = calculate_monthly_user_rewards(current_user.id, *title_bonus_incentive_ids, nil, nil)
    end

    @reward_bonus_total + @two_tier_bonus_total + @a_san_bonus_total + @title_bonus_total
  end

  def set_date
    @search_year, @search_month = set_search_date params, session[:search_rewards_year], session[:search_rewards_month]
  end

  # 特定のユーザーとincentive_idセットの現在の月の合計報酬額を算出
  def calculate_monthly_user_rewards(user_id, *incentive_ids, year, month)
    if year.present? && month.present?
      # 引数で指定された年月を使う
      start_date = Date.new(year, month, 1)
      end_date = start_date.end_of_month
    else
      # 引数が指定されていない場合、現在の月を使う
      start_date = Date.current.beginning_of_month
      end_date = Date.current.end_of_month
    end

    # Rewardモデルから、関連するレコードを検索
    rewards = Reward.where(user_id:, incentive_id: incentive_ids, created_at: start_date..end_date)

    # Incentiveモデルと結合して、incentive_priceの合計を計算
    incentives_total = rewards.joins(:incentive).sum("incentives.incentive_price")

    # Rewardモデルのincentive_priceの合計を計算
    rewards_total = rewards.sum{|reward| reward.incentive_price || 0}

    # 両方の合計を足し合わせる
    @total = incentives_total + rewards_total
  end

  def calculate_y totle_price
    if totle_price > 120_000
      certificate_of_tax_deducted_price = (totle_price - 120_000) * 0.1021
    else
      certificate_of_tax_deducted_price = 0
    end

    if totle_price > 500
      fee_price = 500
    else
      fee_price = 0
    end

    [certificate_of_tax_deducted_price.to_i, fee_price.to_i]
  end
end
