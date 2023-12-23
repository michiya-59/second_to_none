# frozen_string_literal: true

class Incentive < ApplicationRecord
  validates :course_name, presence: true
  validates :incentive_price, presence: true, numericality: {only_integer: true}
  has_many :users, dependent: :nullify
  has_many :rewards, dependent: :destroy

  BONUS = {
    normal: 1,
    advance: 2,
    two_tier_normal: 3,
    two_tier_advance: 4,
    a_san_self_organization: 5,
    a_san_other_organization: 6,
    title_bonus_ruby: 7,
    title_bonus_emerald: 8
  }.freeze

  A_SAN_FLG = {
    a_san_self_organization: 1,
    a_san_other_organization: 2
  }.freeze

  class << self
    def calculate_monthly_user_rewards(user_id, *incentive_ids)
      start_date = Date.current.beginning_of_month
      end_date = Date.current.end_of_month
    
      # Rewardモデルから、関連するレコードを検索
      rewards = Reward.where(user_id:, incentive_id: incentive_ids, created_at: start_date..end_date)
    
      # Incentiveモデルと結合して、incentive_priceの合計を計算
      incentives_total = rewards.joins(:incentive).sum("incentives.incentive_price")
    
      # Rewardモデルのincentive_priceの合計を計算
      rewards_total = rewards.sum(:incentive_price)
    
      # 両方の合計を足し合わせる
      incentives_total + rewards_total
    end
  end
end
