# frozen_string_literal: true

# 報酬の種別及び金額情報のマスターデータ
incentives = [
  { id: 1, course_type: "normal", course_name: "ノーマル", incentive_price: 100000, created_at: Time.current },
  { id: 2, course_type: "advance", course_name: "アドバンス", incentive_price: 140000, created_at: Time.current },
  { id: 3, course_type: "two_tier_normal", course_name: "2ティア(ノーマル)", incentive_price: 30000, created_at: Time.current },
  { id: 4, course_type: "two_tier_advance", course_name: "2ティア(アドバンス)", incentive_price: 40000, created_at: Time.current },
  { id: 5, course_type: "a_san_self_organization", course_name: "自組織3列目以降", incentive_price: 10000, created_at: Time.current },
  { id: 6, course_type: "a_san_other_organization", course_name: "他系列", incentive_price: 15000, created_at: Time.current },
  { id: 7, course_type: "plus_two_tier_ruby", course_name: "2ティア制(ルビープラス額)", incentive_price: 10000, created_at: Time.current },
  { id: 8, course_type: "plus_two_tier_sapphire", course_name: "2ティア制(サファイヤープラス額)", incentive_price: 20000, created_at: Time.current },
]

# グレードのマスターデータ
grades = [
  { id: 1, grade_name: "エグゼクティブ" },
  { id: 2, grade_name: "ルビーエグゼクティブ" },
  { id: 3, grade_name: "エメラルドエグゼクティブ" },
]

# 会員のマスターデータ
users = [
  { id: 1, login_id: "michiya0509", email: "nishino.michiya0509@gmail.com", name: "西野倫也", name_kana: "ニシノミチヤ", birthday: Date.new(1999, 5, 9), phone: "09083675290", password: "MiChiYa0509!?", password_confirmation: "MiChiYa0509!?", status: 1, introducer_id: 99999, left_or_right: nil, admin_flg: 1, gender_id: 1, online_flg: 9, grade_id: 2, created_at: Time.current, updated_at: nil },
  { id: 2, login_id: "seiya", email: "stn230501@gmail.com", name: "鈴木晴也", name_kana: "スズキセイヤ", birthday: Date.new(1999, 12, 9), phone: "08035535646", password: "Seiya01!?", password_confirmation: "Seiya01!?", status: 1, introducer_id: 99999, left_or_right: nil, admin_flg: 1, gender_id: 1, online_flg: 9, grade_id: 3, created_at: Time.current, updated_at: nil },
]

user_addresses = [
  { id: 1, user_id: 1, zip_str3: 252, zip_str4: 0o136, ken: "神奈川県", city: "相模原市緑区上九沢124-5", other_address: nil },
  { id: 2, user_id: 2, zip_str3: 160, zip_str4: 0o023, ken: "東京都", city: "新宿区西新宿3丁目3-13", other_address: nil },
]

user_banks = [
  { id: 1, user_id: 1, bank_name: "三菱UFJ銀行", account_type: "普通預金", branch_name: "橋本支店", branch_number: "012", account_number_hash: "********", account_number_tail: "*******123", account_holder: "NISHINO MICHIYA" },
]

Incentive.create!(incentives)
Grade.create!(grades)
User.create!(users)
UserAddress.create!(user_addresses)
UserBank.create!(user_banks)
ActionView::Template::Error (Asset `error.css` was not declared to be precompiled in production.
nichijou-web-1  | 21:19:03 web.1  | Declare links to your assets in `app/assets/config/manifest.js`