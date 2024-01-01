# frozen_string_literal: true

module OrganizationsHelper
  def return_deduction_price total_price, deduction_price = 0
    return "-#{deduction_price}" if total_price > deduction_price
    0
  end
end
