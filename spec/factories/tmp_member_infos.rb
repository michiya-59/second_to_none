# frozen_string_literal: true

FactoryBot.define do
  factory :tmp_member_info do
    # 基本情報
    login_id{"test123"}
    password{"Password1!"}
    name{"John Doe"}
    name_kana{"ジョン ドウ"}
    email{"john@example.com"}
    phone{"1234567890"}
    birthday{"2000-01-01"}
    gender_id{1}

    # 住所情報
    zip_str3{"100"}
    zip_str4{"0001"}
    ken{"東京都"}
    city{"千代田区"}

    # 銀行情報
    account_type{"普通"}
    bank_name{"テスト銀行"}
    branch_name{"テスト支店"}
    branch_number{"001"}
    account_number_hash{"hashed_account_number"}
    account_holder{"ジョン ドウ"}

    # 契約情報
    introducer_id{1}
    sales_id{1}
    incentive_id{1}
    a_san_flg{true}
  end
end
