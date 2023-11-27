# frozen_string_literal: true

class UserAddress < ApplicationRecord
  VALID_ZIP_CODE3_REGEX = /\A[0-9]{3}\z/
  VALID_ZIP_CODE4_REGEX = /\A[0-9]{4}\z/
  validates :zip_str3, format: {with: VALID_ZIP_CODE3_REGEX, message: "は3桁の数字で入力してください。"}
  validates :zip_str4, format: {with: VALID_ZIP_CODE4_REGEX, message: "は4桁の数字で入力してください。"}
  validates :ken, presence: true
  validates :city, presence: true
  
  class << self
    def create_user_address user, approval
      create!(
        user_id: user.id,
        zip_str3: approval&.zip_str3.to_s,
        zip_str4: approval&.zip_str4.to_s,
        ken: approval&.ken,
        city: approval&.city,
        other_address: approval&.other_address
      )
    end
  end
end
