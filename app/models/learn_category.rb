# frozen_string_literal: true

class LearnCategory < ApplicationRecord
  has_many :learns, dependent: :destroy

  validates :name, presence: true, length: {maximum: 15}
end
