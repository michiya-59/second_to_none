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
end
