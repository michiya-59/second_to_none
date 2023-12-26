# frozen_string_literal: true

# 報酬の種別及び金額情報のマスターデータ
incentives = [
  { course_type: "normal", course_name: "ノーマル", incentive_price: 100000, created_at: Time.current },
  { course_type: "advance", course_name: "アドバンス", incentive_price: 140000, created_at: Time.current },
  { course_type: "two_tier_normal", course_name: "2ティア(ノーマル)", incentive_price: 30000, created_at: Time.current },
  { course_type: "two_tier_advance", course_name: "2ティア(アドバンス)", incentive_price: 40000, created_at: Time.current },
  { course_type: "a_san_self_organization", course_name: "自組織3列目以降", incentive_price: 10000, created_at: Time.current },
  { course_type: "a_san_other_organization", course_name: "他系列", incentive_price: 15000, created_at: Time.current },
  { course_type: "title_bonus_ruby", course_name: "タイトルボーナス(ルビー)", incentive_price: 30000, created_at: Time.current },
  { course_type: "title_bonus_emerald", course_name: "タイトルボーナス(エメラルド)", incentive_price: 50000, created_at: Time.current }
]

# グレードのマスターデータ
grades = [
  { grade_name: "エグゼクティブ" },
  { grade_name: "ルビーエグゼクティブ" },
  { grade_name: "エメラルドエグゼクティブ" },
  { id: 99, grade_name: "ノーマル" }
]

# 新規MTカテゴリー
learn_categories = [
  { name: "新規MT", created_at: Time.current, updated_at: nil}
]

# 会員のマスターデータ
users = [
  { login_id: "admin001", email: "stn230501@gmail.com", name: "鈴木晴也", name_kana: "スズキセイヤ", birthday: Date.new(1999, 12, 9), phone: "08035535646", password: "Admin001!", password_confirmation: "Admin001!", status: 1, introducer_id: 99999, admin_flg: 1, gender_id: 1, online_flg: 9, grade_id: 3, created_at: Time.current, updated_at: nil }
]

user_addresses = [
  { user_id: 1, zip_str3: "252", zip_str4: "0136", ken: "神奈川県", city: "相模原市緑区上九沢124-5", other_address: nil }
]

user_banks = [
  { user_id: 1, bank_name: "三菱UFJ銀行", account_type: 1, branch_name: "橋本支店", branch_number: "012", account_number_hash: "0982910", account_number_tail: "*****123", account_holder: "NISHINO MICHIYA" }
]

Incentive.create!(incentives)
LearnCategory.create!(learn_categories)
Grade.create!(grades)
User.create!(users)
UserAddress.create!(user_addresses)
UserBank.create!(user_banks)
