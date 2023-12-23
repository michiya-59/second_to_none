# frozen_string_literal: true

class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @user_address = UserAddress.find_by(user_id: params[:id])
    @user_bank = UserBank.find_by(user_id: params[:id])
  end

  def edit
    case params[:type]
    when "base"
      @user_info = User.find(params[:id])
    when "address"
      @user_info = UserAddress.find_by(user_id: params[:id])
    when "bank"
      @user_info = UserBank.find_by(user_id: params[:id])
    end
  end

  def update
    @type = determine_update_type
    @user_info = find_user_info(@type)

    case @type
    when "base"
      if @user_info.update(user_base_info_params)
        flash[:success] = "基本情報の更新が完了しました。"
        redirect_to user_path(@user_info)
      else
        flash[:error] = @user_info.errors.full_messages
        redirect_to edit_user_path(@user_info, type: "base")
      end
    when "address"
      if @user_info.update(user_address_info_params)
        flash[:success] = "住所情報の更新が完了しました。"
        redirect_to user_path(params[:id])
      else
        flash[:error] = @user_info.errors.full_messages
        redirect_to edit_user_path(@user_info, type: "address")
      end
    when "bank"
      @user_info.assign_attributes(account_number_tail: "*****#{@user_info.account_number_hash[-3..]}")
      if @user_info.update(user_bank_info_params)
        flash[:success] = "銀行情報の更新が完了しました。"
        redirect_to user_path(params[:id])
      else
        flash[:error] = @user_info.errors.full_messages
        redirect_to edit_user_path(@user_info, type: "bank")
      end
    end
  end

  private

  def user_base_info_params
    params.require(:user).permit(:login_id, :name, :name_kana, :email, :phone, :birthday, :gender_id, :user_image)
  end

  def user_address_info_params
    params.require(:user_address).permit(:zip_str3, :zip_str4, :ken, :city, :other_address)
  end

  def user_bank_info_params
    params.require(:user_bank).permit(:account_type, :bank_name, :branch_name, :branch_number, :account_holder, :account_number_tail)
  end

  def determine_update_type
    params.dig(:user, :type) || params.dig(:user_address, :type) || params.dig(:user_bank, :type)
  end

  def find_user_info type
    case type
    when "base"
      User.find(params[:id])
    when "address"
      UserAddress.find_by(user_id: params[:id])
    when "bank"
      UserBank.find_by(user_id: params[:id])
    end
  end
end
