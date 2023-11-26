# frozen_string_literal: true

class User < ApplicationRecord
  has_one_attached :image
  has_secure_password
  has_many :learns, dependent: :nullify
  # 以下の2つの関連名を修正します
  has_many :introduced_tmp_member_infos, foreign_key: "introducer_id", class_name: "TmpMemberInfo", dependent: :nullify, inverse_of: :introducer
  has_many :sales_tmp_member_infos, foreign_key: "sales_id", class_name: "TmpMemberInfo", dependent: :nullify, inverse_of: :sales
  belongs_to :incentive, optional: true
  # 親としての関連
  has_many :child_relationships, foreign_key: "parent_id", class_name: "Relationship", dependent: :nullify, inverse_of: :parent
  # 子としての関連
  has_many :parent_relationships, foreign_key: "child_id", class_name: "Relationship", dependent: :nullify, inverse_of: :child
  has_many :rewards, dependent: :destroy

  class << self
    def create_user approval
      create!(
        login_id: approval&.login_id,
        email: approval&.email,
        name: approval&.name,
        name_kana: approval&.name_kana,
        birthday: approval&.birthday,
        phone: approval&.phone,
        password_digest: approval&.password_digest,
        status: 1,
        introducer_id: approval&.introducer_id,
        left_or_right: approval&.left_or_right,
        admin_flg: 9,
        gender_id: approval&.gender_id,
        online_flg: 9,
        grade_id: 99,
        incentive_id: approval&.incentive_id
      )
    end
  end
end
