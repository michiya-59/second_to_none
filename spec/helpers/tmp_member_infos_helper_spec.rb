# frozen_string_literal: true

require "rails_helper"

RSpec.describe TmpMemberInfosHelper, type: :helper do
  describe ".get_default_value" do
    let!(:session_data){{tmp_member_info_data: {"name" => "Alice", "age" => "30", "gender" => "2"}}}

    context "セッションデータが存在する場合" do
      before do
        allow(helper).to receive(:session).and_return(session_data)
      end

      it "textまたはtextareaの場合、正しいデフォルト値を取得する" do
        expect(helper.get_default_value("name", "text")).to eq "Alice"
      end

      it "selectまたはradioの場合、整数として正しいデフォルト値を取得する" do
        expect(helper.get_default_value("gender", "select")).to eq 2
      end
    end

    context "セッションデータが存在しない場合" do
      before do
        allow(helper).to receive(:session).and_return({})
      end

      it "textまたはtextareaの場合、空文字列を返す" do
        expect(helper.get_default_value("name", "text")).to eq ""
      end

      it "selectまたはradioの場合、1を返す" do
        expect(helper.get_default_value("gender", "select")).to eq 1
      end
    end
  end

  describe "#get_default_birthday_value" do
    context "セッションデータが存在する場合" do
      context "年、月、日が全て存在する" do
        let!(:session_data){{tmp_member_info_data: {"birthday(1i)" => "2000", "birthday(2i)" => "12", "birthday(3i)" => "31"}}}

        before do
          allow(helper).to receive(:session).and_return(session_data)
        end

        it "Dateオブジェクトとして正しい誕生日を返す" do
          expect(helper.get_default_birthday_value).to eq Date.new(2000, 12, 31)
        end
      end

      context "年、月、日が一つでも欠けている" do
        let!(:session_data){{tmp_member_info_data: {"birthday(1i)" => "2000", "birthday(2i)" => nil, "birthday(3i)" => "31"}}}

        before do
          allow(helper).to receive(:session).and_return(session_data)
        end

        it "デフォルトのDateオブジェクト（1990年1月1日）を返す" do
          expect(helper.get_default_birthday_value).to eq Date.new(1990, 1, 1)
        end
      end
    end

    context "セッションデータが存在しない場合" do
      before do
        allow(helper).to receive(:session).and_return({})
      end

      it "デフォルトのDateオブジェクト（1990年1月1日）を返す" do
        expect(helper.get_default_birthday_value).to eq Date.new(1990, 1, 1)
      end
    end
  end
end
