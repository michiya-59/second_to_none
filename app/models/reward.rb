# frozen_string_literal: true

class Reward < ApplicationRecord
  belongs_to :user
  belongs_to :incentive

  class << self
    # 新規会員を承認するに伴って紹介者や営業担当者、紹介者の親ユーザの2ティア制などの報酬登録の処理
    # params[User] user 新規会員ユーザ情報
    # params[TmpMemberInfo] 仮登録情報
    def create_rewards user, approval
      create_incentive_rewards user if user.introducer_id.present? && user.incentive_id.present?

      return if approval&.sales_id.blank?

      create_approval_rewards approval
      
    end

    private

    # 紹介者と2ティア制の登録処理
    # params[User] user 新規会員ユーザ情報
    def create_incentive_rewards user
      case user.incentive_id
      when Incentive::BONUS[:normal]
        create_reward_for_user(user.introducer_id, :normal)
        create_two_tier_bonus(user.introducer_id, :two_tier_normal)
      when Incentive::BONUS[:advance]
        create_reward_for_user(user.introducer_id, :advance)
        create_two_tier_bonus(user.introducer_id, :two_tier_advance)
      end
    end

    # aさんの報酬ボーナス、営業担当者のタイトルボーナス登録処理
    # params[User] approval 新規会員ユーザ情報
    def create_approval_rewards approval
      return if approval.a_san_flg.blank?

      if approval.a_san_flg == Incentive::A_SAN_FLG[:a_san_self_organization]
        # aさんが自組織3列目以降の時のボーナス登録
        create_a_san_reward approval.sales_id, :a_san_self_organization
      elsif approval.a_san_flg == Incentive::A_SAN_FLG[:a_san_other_organization]
        # aさんが他系列の時のボーナス登録
        create_a_san_reward approval.sales_id, :a_san_other_organization
      end

      grade = User.select(:grade_id).find(approval.sales_id).grade_id
      if grade == Grade::GRADE[:ruby]
        # 営業担当者のグレードがルビーエグゼクティブの時のタイトルボーナス登録
        create_title_bonus_reword approval.sales_id, :title_bonus_ruby
      elsif grade == Grade::GRADE[:emerald]
        # 営業担当者のグレードがエメラルドーエグゼクティブの時のタイトルボーナス登録
        create_title_bonus_reword approval.sales_id, :title_bonus_emerald
      end
    end

    # 紹介者の「ノーマルコース」または「アドバンスコース」の登録処理
    # params[User] user Userモデルからidを取り出すためのオブジェクト
    # params[Integer] incentive 報酬コースのID（:normal：ノーマルコース, advance：アドバンスコース）
    def create_reward_for_user introducer_id, incentive
      create!(
        user_id: introducer_id,
        incentive_id: Incentive::BONUS[incentive]
      )
    end

    # 紹介者の上の親ユーザを取得して2ティア制ボーナスを登録する処理
    # params[Integer] introducer_id 紹介者ID
    # params[Symbol] tier_type incentive 2ティア制のID（two_tier_normal；2ティア制のルビー, two_tier_advance:2ティア制のエメラルド）
    def create_two_tier_bonus introducer_id, tier_type
      parent_id = Relationship.find_by(child_id: introducer_id)&.parent_id
      return if parent_id.blank?

      grade = User.select(:grade_id).find(parent_id).grade_id
      two_tier_bonus_price = calculate_bonus_price_for_grade(grade)

      create!(
        user_id: parent_id,
        incentive_id: Incentive::BONUS[tier_type],
        incentive_price: two_tier_bonus_price
      )
    end

    # 営業を決めた人のaさんボーナスの登録処理
    # params[Integer] sales_id 営業を決めたユーザID
    # params[Integer] a_san_type aさんのタイプ（a_san_self_organization: 自組織3列目以降, a_san_other_organization: 他系列）
    def create_a_san_reward sales_id, a_san_type
      create!(
        user_id: sales_id,
        incentive_id: Incentive::BONUS[a_san_type]
      )
    end

    # 営業を決めた人のaさんボーナスの登録処理
    # params[Integer] sales_id 営業を決めたユーザID
    # params[Integer] title_bonus_type タイトルボーナスのタイプ（title_bonus_ruby: グレードがルビー title_bonus_emerald: グレードがエメラルド）
    def create_title_bonus_reword sales_id, title_bonus_type
      create!(
        user_id: sales_id,
        incentive_id: Incentive::BONUS[title_bonus_type]
      )
    end

    def calculate_bonus_price_for_grade grade
      case grade
      when Grade::GRADE[:ruby]
        10_000
      when Grade::GRADE[:emerald]
        20_000
      end
    end
  end
end
