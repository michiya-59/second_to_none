# frozen_string_literal: true

module ApplicationHelper
  def get_current_path
    request.fullpath
  end
end
