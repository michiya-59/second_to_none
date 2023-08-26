# frozen_string_literal: true

# spec/models/tmp_member_info_spec.rb

require "rails_helper"

RSpec.describe TmpMemberInfo, type: :model do
  describe "基本情報のバリデーション（base）" do
    let!(:tmp_member_info){build(:tmp_member_info, current_step: "base")}

    context "ログインIDに関するテスト" do
      it "半角英数字以外が含まれていレバ有効" do
        tmp_member_info.login_id = "test123"
        expect(tmp_member_info).to be_valid
        tmp_member_info.invalid?
        expect(tmp_member_info.errors[:login_id]).to eq []
      end
      it "半角英数字以外が含まれていれば無効" do
        tmp_member_info.login_id = "test123!"
        expect(tmp_member_info).to be_invalid
        tmp_member_info.invalid?
        expect(tmp_member_info.errors[:login_id]).to include("は半角英数字のみで入力してください。")
      end
    end

    context "パスワードに関するテスト" do
      it "8文字以上で、大文字、小文字、数字、特殊文字が含まれていれば有効" do
        tmp_member_info.password = "Password1!"
        expect(tmp_member_info).to be_valid
        tmp_member_info.invalid?
        expect(tmp_member_info.errors[:password]).to eq []
      end
      it "8文字未満であれば無効" do
        tmp_member_info.password = "Pass1!"
        expect(tmp_member_info).to be_invalid
        tmp_member_info.invalid?
        expect(tmp_member_info.errors[:password]).to include("は8文字以上でなければなりません。")
      end
      it "小文字が含まれなければ無効" do
        tmp_member_info.password = "PASSWORD1!"
        expect(tmp_member_info).to be_invalid
        tmp_member_info.invalid?
        expect(tmp_member_info.errors[:password]).to include("は少なくとも1つの小文字を含む必要があります。")
      end
      it "大文字が含まれなければ無効" do
        tmp_member_info.password = "password1!"
        expect(tmp_member_info).to be_invalid
        tmp_member_info.invalid?
        expect(tmp_member_info.errors[:password]).to include("は少なくとも1つの大文字を含む必要があります。")
      end
      it "数字が含まれなければ無効" do
        tmp_member_info.password = "Password!"
        expect(tmp_member_info).to be_invalid
        tmp_member_info.invalid?
        expect(tmp_member_info.errors[:password]).to include("は少なくとも1つの数字を含む必要があります。")
      end
      it "特殊文字が含まれなければ無効" do
        tmp_member_info.password = "Password1"
        expect(tmp_member_info).to be_invalid
        tmp_member_info.invalid?
        expect(tmp_member_info.errors[:password]).to include("は少なくとも1つの特殊文字を含む必要があります。")
      end
    end

    context "名前に関するテスト" do
      it "存在していれば有効" do
        tmp_member_info.name = "太朗"
        expect(tmp_member_info).to be_valid
        tmp_member_info.invalid?
        expect(tmp_member_info.errors[:name]).to eq []
      end
      it "存在しなければ無効" do
        tmp_member_info.name = nil
        expect(tmp_member_info).to be_invalid
        tmp_member_info.invalid?
        expect(tmp_member_info.errors[:name]).to include("を入力してください")
      end
      it "30文字を超える場合無効" do
        tmp_member_info.name = "a" * 31
        expect(tmp_member_info).to be_invalid
        tmp_member_info.invalid?
        expect(tmp_member_info.errors[:name]).to include("は30文字以内で入力してください")
      end
    end

    context "名前(カナ)に関するテスト" do
      it "存在していれば有効" do
        tmp_member_info.name_kana = "タロウ"
        expect(tmp_member_info).to be_valid
        tmp_member_info.invalid?
        expect(tmp_member_info.errors[:name_kana]).to eq []
      end
      it "存在しなければ無効" do
        tmp_member_info.name_kana = nil
        expect(tmp_member_info).to be_invalid
        tmp_member_info.invalid?
        expect(tmp_member_info.errors[:name_kana]).to include("を入力してください")
      end
    end

    context "Eメールに関するテスト" do
      it "フォーマットが正しい場合有効" do
        tmp_member_info.email = "test@test.com"
        expect(tmp_member_info).to be_valid
        tmp_member_info.invalid?
        expect(tmp_member_info.errors[:email]).to eq []
      end
      it "255文字を超える場合無効" do
        tmp_member_info.email = "#{'a' * 250}@example.com"
        expect(tmp_member_info).to be_invalid
        tmp_member_info.invalid?
        expect(tmp_member_info.errors[:email]).to include("は255文字以内で入力してください")
      end
      it "フォーマットが正しくない場合無効" do
        tmp_member_info.email = "invalid_email"
        expect(tmp_member_info).to be_invalid
        tmp_member_info.invalid?
        expect(tmp_member_info.errors[:email]).to include("は不正な値です")
      end
    end

    context "電話番号に関するテスト" do
      it "10文字の場合有効" do
        tmp_member_info.phone = "09083675290"
        expect(tmp_member_info).to be_valid
        tmp_member_info.invalid?
        expect(tmp_member_info.errors[:phone]).to eq []
      end
      it "空の場合無効" do
        tmp_member_info.phone = ""
        expect(tmp_member_info).to be_invalid
        tmp_member_info.invalid?
        expect(tmp_member_info.errors[:phone]).to include("は10文字または11文字で入力してください。")
      end
      it "10文字未満の場合無効" do
        tmp_member_info.phone = "123456789"
        expect(tmp_member_info).to be_invalid
        tmp_member_info.invalid?
        expect(tmp_member_info.errors[:phone]).to include("は10文字または11文字で入力してください。")
      end
      it "11文字を超える場合無効" do
        tmp_member_info.phone = "123456789012"
        expect(tmp_member_info).to be_invalid
        tmp_member_info.invalid?
        expect(tmp_member_info.errors[:phone]).to include("は10文字または11文字で入力してください。")
      end
    end

    context "生年月日に関するテスト" do
      it "存在していれば有効" do
        tmp_member_info.birthday = Time.zone.today
        expect(tmp_member_info).to be_valid
        tmp_member_info.invalid?
        expect(tmp_member_info.errors[:birthday]).to eq []
      end
      it "存在しなければ無効" do
        tmp_member_info.birthday = nil
        expect(tmp_member_info).to be_invalid
        tmp_member_info.invalid?
        expect(tmp_member_info.errors[:birthday]).to include("を入力してください")
      end
    end

    context "性別に関するテスト" do
      it "存在していれば有効" do
        tmp_member_info.gender_id = 1
        expect(tmp_member_info).to be_valid
        tmp_member_info.invalid?
        expect(tmp_member_info.errors[:gender_id]).to eq []
      end
      it "存在しなければ無効" do
        tmp_member_info.gender_id = nil
        expect(tmp_member_info).to be_invalid
        tmp_member_info.invalid?
        expect(tmp_member_info.errors[:gender_id]).to include("を入力してください")
      end
    end
  end

  describe "住所情報のバリデーション（address）" do
    let!(:tmp_member_info){build(:tmp_member_info, current_step: "address")}

    context "郵便番号3桁に関するテスト" do
      it "3桁の数字のみの場合有効" do
        tmp_member_info.zip_str3 = 252
        expect(tmp_member_info).to be_valid
        tmp_member_info.invalid?
        expect(tmp_member_info.errors[:zip_str3]).to eq []
      end
      it "3桁の数字ではない場合無効" do
        tmp_member_info.zip_str3 = 10
        expect(tmp_member_info).to be_invalid
        tmp_member_info.invalid?
        expect(tmp_member_info.errors[:zip_str3]).to include("は3桁の数字で入力してください。")
      end
    end

    context "郵便番号4桁に関するテスト" do
      it "4桁の数字のみの場合有効" do
        tmp_member_info.zip_str4 = 1111
        expect(tmp_member_info).to be_valid
        tmp_member_info.invalid?
        expect(tmp_member_info.errors[:zip_str3]).to eq []
      end
      it "4桁の数字ではない場合無効" do
        tmp_member_info.zip_str4 = 10
        expect(tmp_member_info).to be_invalid
        tmp_member_info.invalid?
        expect(tmp_member_info.errors[:zip_str4]).to include("は4桁の数字で入力してください。")
      end
    end

    context "都道府県に関するテスト" do
      it "存在していれば有効" do
        tmp_member_info.ken = "神奈川県"
        expect(tmp_member_info).to be_valid
        tmp_member_info.invalid?
        expect(tmp_member_info.errors[:ken]).to eq []
      end
      it "存在しなければ無効" do
        tmp_member_info.ken = nil
        expect(tmp_member_info).to be_invalid
        tmp_member_info.invalid?
        expect(tmp_member_info.errors[:ken]).to include("を入力してください")
      end
    end

    context "市区町村に関するテスト" do
      it "存在していれば有効" do
        tmp_member_info.city = "多摩区"
        expect(tmp_member_info).to be_valid
        tmp_member_info.invalid?
        expect(tmp_member_info.errors[:city]).to eq []
      end
      it "存在しなければ無効" do
        tmp_member_info.city = nil
        expect(tmp_member_info).to be_invalid
        tmp_member_info.invalid?
        expect(tmp_member_info.errors[:city]).to include("を入力してください")
      end
    end
  end

  describe "銀行情報のバリデーション（bank）" do
    let!(:tmp_member_info){build(:tmp_member_info, current_step: "bank")}

    context "金融機関名に関するテスト" do
      it "存在していれば有効" do
        tmp_member_info.account_type = "横浜銀行"
        expect(tmp_member_info).to be_valid
        tmp_member_info.invalid?
        expect(tmp_member_info.errors[:account_type]).to eq []
      end
      it "存在しなければ無効" do
        tmp_member_info.account_type = nil
        expect(tmp_member_info).to be_invalid
        tmp_member_info.invalid?
        expect(tmp_member_info.errors[:account_type]).to include("を入力してください")
      end
    end

    context "支店名に関するテスト" do
      it "存在していれば有効" do
        tmp_member_info.branch_name = "テスト支店"
        expect(tmp_member_info).to be_valid
        tmp_member_info.invalid?
        expect(tmp_member_info.errors[:branch_name]).to eq []
      end
      it "存在しなければ無効" do
        tmp_member_info.branch_name = nil
        expect(tmp_member_info).to be_invalid
        tmp_member_info.invalid?
        expect(tmp_member_info.errors[:branch_name]).to include("を入力してください")
      end
    end

    context "支店番号に関するテスト" do
      it "存在していれば有効" do
        tmp_member_info.branch_number = 111
        expect(tmp_member_info).to be_valid
        tmp_member_info.invalid?
        expect(tmp_member_info.errors[:branch_number]).to eq []
      end
      it "存在しなければ無効" do
        tmp_member_info.branch_number = nil
        expect(tmp_member_info).to be_invalid
        tmp_member_info.invalid?
        expect(tmp_member_info.errors[:branch_number]).to include("を入力してください")
      end
    end
    context "口座番号に関するテスト" do
      it "存在していれば有効" do
        tmp_member_info.account_number_hash = "121212"
        expect(tmp_member_info).to be_valid
        tmp_member_info.invalid?
        expect(tmp_member_info.errors[:account_number_hash]).to eq []
      end
      it "存在しなければ無効" do
        tmp_member_info.account_number_hash = nil
        expect(tmp_member_info).to be_invalid
        tmp_member_info.invalid?
        expect(tmp_member_info.errors[:account_number_hash]).to eq %w(を入力してください)
      end
    end
  end
end
