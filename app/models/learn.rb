# frozen_string_literal: true

class Learn < ApplicationRecord
  has_one_attached :document_file
  has_one_attached :video_file
  has_many :video_views, dependent: :nullify
  has_many :tasks, dependent: :destroy

  belongs_to :learn_category
  belongs_to :user

  validates :name, presence: true, length: {maximum: 30}

  scope :created_this_month, ->{where("extract(year from created_at) = ? AND extract(month from created_at) = ?", Time.current.year, Time.current.month)}
end
