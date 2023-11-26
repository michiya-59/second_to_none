# frozen_string_literal: true

class Grade < ApplicationRecord
  GRADE = {
    not: 99,
    normal: 1,
    ruby: 2,
    emerald: 3
  }.freeze
end
