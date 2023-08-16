require 'rails_helper'

RSpec.describe "TmpMemberInfos", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/tmp_member_infos/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/tmp_member_infos/create"
      expect(response).to have_http_status(:success)
    end
  end

end
