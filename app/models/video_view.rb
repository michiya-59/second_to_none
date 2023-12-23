# frozen_string_literal: true

class VideoView < ApplicationRecord
  belongs_to :user
  belongs_to :learn
end
