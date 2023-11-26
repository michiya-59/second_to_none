# frozen_string_literal: true

class UserBank < ApplicationRecord
  class << self
    def create_user_bank user, approval
      create!(
        user_id: user.id,
        account_type: approval&.account_type,
        bank_name: approval&.bank_name,
        branch_name: approval&.branch_name,
        branch_number: approval&.branch_number,
        account_number_hash: approval&.account_number_hash,
        account_number_tail: approval&.account_number_tail,
        account_holder: approval&.account_holder
      )
    end
  end
end
