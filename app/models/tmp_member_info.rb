# frozen_string_literal: true

class TmpMemberInfo < ApplicationRecord
  attr_accessor :current_step

  has_secure_password
  VALID_ALPHANUMERIC_REGEX = /\A[a-zA-Z0-9]+\z/
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_ZIP_CODE3_REGEX = /\A[0-9]{3}\z/
  VALID_ZIP_CODE4_REGEX = /\A[0-9]{4}\z/

  with_options if: -> { current_step == "base" } do
    validates :login_id, format: { with: VALID_ALPHANUMERIC_REGEX, message: "は半角英数字のみで入力してください。" }
    validate :check_password
    validates :name, presence: true, length: { maximum: 30 }
    validates :name_kana, presence: true
    validates :email, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }
    validates :phone, length: { in: 10..11, message: "は10文字または11文字で入力してください。" }
    validates :birthday, presence: true
    validates :gender_id, presence: true
  end

  with_options if: -> { current_step == "address" } do
    validates :zip_str3, format: { with: VALID_ZIP_CODE3_REGEX, message: "は3桁の数字で入力してください。" }
    validates :zip_str4, format: { with: VALID_ZIP_CODE4_REGEX, message: "は4桁の数字で入力してください。" }
    validates :ken, presence: true
    validates :city, presence: true
  end

  with_options if: -> { current_step == "bank" } do
    validates :account_type, presence: true
    validates :bank_name, presence: true
    validates :branch_name, presence: true
    validates :branch_number, presence: true
    validates :account_number_hash, presence: true
    validates :account_holder, presence: true
  end

  with_options if: -> { current_step == "contract" } do
    validates :introducer_id, presence: true
    validates :left_or_right, presence: true
    validates :sales_id, presence: true
    validates :incentive_id, presence: true
    validates :a_san_flg, presence: true
  end

  CURRENT_STEP = {
    "base" => 1,
    "address" => 2,
    "bank" => 3,
    "contract" => 4,
  }.freeze

  private

    def check_password
      return if password.blank?

      if password.length <= 8
        errors.add(:password, "は8文字以上でなければなりません。")
        return
      end
      unless password =~ /[a-z]/
        errors.add(:password, "は少なくとも1つの小文字を含む必要があります。")
        return
      end
      unless password =~ /[A-Z]/
        errors.add(:password, "は少なくとも1つの大文字を含む必要があります。")
        return
      end
      unless password =~ /\d/
        errors.add(:password, "は少なくとも1つの数字を含む必要があります。")
        return
      end
      special_characters = "!@#$%^&*()-_=+[]{}|;:'\",.<>?/"
      unless password =~ /[#{Regexp.escape(special_characters)}]/
        errors.add(:password, "は少なくとも1つの特殊文字を含む必要があります。")
        nil
      end
    end
end
