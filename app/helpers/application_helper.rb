# frozen_string_literal: true

module ApplicationHelper
  def get_current_path
    request.fullpath
  end

  def page_year_month_include? page, year, month
    if page.present? && year && month
      true
    else
      false
    end
  end
end
