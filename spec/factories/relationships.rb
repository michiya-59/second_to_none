# frozen_string_literal: true

FactoryBot.define do
  factory :relationship do
    parent_id{1}
    child_id{1}
    position{"MyString"}
  end
end
