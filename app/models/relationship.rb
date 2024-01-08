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

    def find_descendants parent_id
      direct_children = Relationship.where(parent_id: parent_id).pluck(:child_id)
      return [] if direct_children.blank?

      # 子孫を再帰的に探索する
      descendants = direct_children.dup
      direct_children.each do |child_id|
        descendants += find_descendants(child_id)
      end

      descendants.uniq
    end
  end
end
