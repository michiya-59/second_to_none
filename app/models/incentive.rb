# frozen_string_literal: true

class Incentive < ApplicationRecord
  validates :course_name, presence: true
  validates :incentive_price, presence: true, numericality: {only_integer: true}
end
