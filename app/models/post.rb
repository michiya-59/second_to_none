# frozen_string_literal: true

class Post < ApplicationRecord
  validates :title, presence: true, length: {maximum: 35}
  validates :body, presence: true
  validates :category_flg, presence: true
  has_one_attached :event_image
  attr_accessor :remove_event_image

  after_save :purge_event_image, if: ->{remove_event_image && event_image.attached?}

  scope :created_this_month, ->{where("extract(year from created_at) = ? AND extract(month from created_at) = ?", Time.current.year, Time.current.month)}

  private

  def purge_event_image
    event_image.purge
  end
end
