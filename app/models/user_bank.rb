# frozen_string_literal: true

class UserBank < ApplicationRecord
  validates :account_type, presence: true
  validates :bank_name, presence: true
  validates :branch_name, presence: true
  validates :branch_number, presence: true
  validates :account_number_hash, presence: true
  validates :account_holder, presence: true
  
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
