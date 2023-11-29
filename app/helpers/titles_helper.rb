# frozen_string_literal: true

module TitlesHelper
  def next_title_border user
    case user&.grade_id
    when 99
      %w(normal_border normal)
    when 1
      %w(ruby_border ruby)
    when 2, 3
      %w(emerald_border emerald)
    else
      "none"
    end
  end
end
