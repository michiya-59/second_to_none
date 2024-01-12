# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :learn
  belongs_to :user
  has_many_attached :files

  validates :comment, presence: true
end
