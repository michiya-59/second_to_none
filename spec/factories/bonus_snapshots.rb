# frozen_string_literal: true

FactoryBot.define do
  factory :bonus_snapshot do
    user{nil}
    reward_month{"MyString"}
    reward_bonus_total{1}
    two_tier_bonus_total{1}
    title_bonus_total{1}
    a_san_bonus_total{1}
    tax_withholding{1}
    administration_fee{1}
    cap_adjustment_money{1}
    total_price{1}
    total_payment_price{1}
  end
end
