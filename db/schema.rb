# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_08_12_110248) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "incentives", force: :cascade do |t|
    t.string "course_type", null: false, comment: "normal、advance、two_ter_normal、two_tier_advance、a_san_self_organization、a_san_other_organization, plus_two_tier_ruby, plus_two_tier_sapphire"
    t.string "course_name", null: false, comment: "ノーマル、アドバンス、２ティア(ノーマル)、２ティア(アドバンス)、自組織３段目以降、他系列、ルビー、サファイヤ"
    t.integer "incentive_price", null: false, comment: "初期値【100000：ノーマルコース、140000：アドバンス、30000；２ティア(ノーマル)、40000：２ティア（アドバンス）、10000：自組織３段目以降発生、15000：他系列契約時に発生、10000：ルビー、20000：サファイヤ】"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tmp_member_infos", force: :cascade do |t|
    t.integer "user_id", null: false, comment: "ユーザID"
    t.string "email", null: false, comment: "メールアドレス"
    t.string "name", null: false, comment: "氏名"
    t.string "name_kana", null: false, comment: "氏名カナ"
    t.datetime "birthday", null: false, comment: "誕生日"
    t.string "phone", null: false, comment: "携帯番号"
    t.string "login_id", null: false, comment: "ログインID"
    t.string "password_digest", null: false, comment: "パスワードダイジェスト"
    t.integer "introducer_id", null: false, comment: "紹介者ID"
    t.string "left_or_right", null: false, comment: "紹介者が右か左かの情報"
    t.integer "gender_id", null: false, comment: "性別(男：１、女：０)"
    t.string "zip_str3", null: false, comment: "郵便番号の前3桁"
    t.string "zip_str4", null: false, comment: "郵便番号の前4桁"
    t.string "ken", null: false, comment: "都道府県"
    t.string "city", null: false, comment: "市区町村"
    t.string "other_address", null: false, comment: "建物名・部屋番号"
    t.string "account_type", null: false, comment: "預金種別"
    t.string "bank_name", null: false, comment: "金融機関名"
    t.string "branch_name", null: false, comment: "支店名"
    t.string "branch_number", null: false, comment: "支店番号"
    t.string "account_number_hash", null: false, comment: "口座番号（ハッシュ化して見えないようにする）"
    t.string "account_number_tail", null: false, comment: "口座番号の末尾３桁"
    t.string "account_holder", null: false, comment: "口座名義"
    t.integer "sales_id", null: false, comment: "営業担当ID"
    t.integer "incentive_id", null: false, comment: "コースタイプ（１：ノーマル、２：アドバンス）"
    t.integer "a_san_flg", null: false, comment: "自組織３列目または他系列のaさんであるかどうか（１：自組織３列目以降、２：他系列、９：どれでもない）"
    t.integer "approval_id", null: false, comment: "承認ID（１：承認済み、２：承認待ち）"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
