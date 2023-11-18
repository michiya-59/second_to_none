# frozen_string_literal: true

FactoryBot.define do
  factory :reservation do
    user{nil}
    seminar{nil}
    join_status{1}
  end
end
