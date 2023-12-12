# frozen_string_literal: true

module OrganizationsHelper
  def return_deduction_price total_price, deduction_price = 0
    if total_price > deduction_price
      return "-#{deduction_price}"
    else
      return 0
    end
  end
end
