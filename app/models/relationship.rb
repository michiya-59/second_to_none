# frozen_string_literal: true

class Relationship < ApplicationRecord
  # parent_id は User モデルの id に対応する
  belongs_to :parent, class_name: "User"
  # child_id は User モデルの id に対応する
  belongs_to :child, class_name: "User"

  class << self
    def create_relationship user
      create!(
        parent_id: user.introducer_id,
        child_id: user.id
      )
    end
  end
end
