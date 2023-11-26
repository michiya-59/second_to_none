# frozen_string_literal: true

class UserAddress < ApplicationRecord
  class << self
    def create_user_address user, approval
      create!(
        user_id: user.id,
        zip_str3: approval&.zip_str3,
        zip_str4: approval&.zip_str4,
        ken: approval&.ken,
        city: approval&.city,
        other_address: approval&.other_address
      )
    end
  end
end
