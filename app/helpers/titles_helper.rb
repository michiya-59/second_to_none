# frozen_string_literal: true

module TitlesHelper
  def get_title_color user
    case user&.grade_id
    when 99
      "not_title"
    when 1
      "normal"
    when 2
      "ruby"
    when 3
      "sapphire"
    else
      "none"
    end
  end

  def next_title_border user
    case user&.grade_id
    when 99
      %w(normal_border normal)
    when 1
      %w(ruby_border ruby)
    when 2, 3
      %w(sapphire_border sapphire)
    else
      "none"
    end
  end
end
