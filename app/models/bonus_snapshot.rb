# frozen_string_literal: true

class BonusSnapshot < ApplicationRecord
  belongs_to :user

  class << self
    def create_snapshot bonus_info
      create(
        user_id: bonus_info[:user_id],
        reward_snapshots_date: bonus_info[:reward_snapshots_date],
        reward_bonus_total: bonus_info[:reward_bonus_total],
        two_tier_bonus_total: bonus_info[:two_tier_bonus_total],
        title_bonus_total: bonus_info[:title_bonus_total],
        a_san_bonus_total: bonus_info[:a_san_bonus_total],
        tax_withholding: bonus_info[:tax_withholding],
        administration_fee: bonus_info[:administration_fee],
        cap_adjustment_money: bonus_info[:cap_adjustment_money],
        total_price: bonus_info[:total_price],
        total_payment_price: bonus_info[:total_payment_price]
      )
    end
  end
end
