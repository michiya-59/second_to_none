# frozen_string_literal: true

require "line_notifier"

class TmpMemberInfosController < ApplicationController
  before_action :set_tmp_member_info, only: %i(new confirm get_confirm create)
  skip_before_action :authenticate_user, :redirect_not_logged_in, :redirect_not_session

  def new
    session[:tmp_member_info_data] ||= {}

    if session[:tmp_member_info_data]["login_id"]
      if validete_uniq? session[:tmp_member_info_data]["login_id"], "login_id"
        flash[:error] = ["入力したログインIDは他のユーザ使っています。別のものにしてください。"]
      elsif validete_uniq? session[:tmp_member_info_data]["email"], "email"
        flash[:error] = ["入力したメールアドレスは他のユーザ使っています。別のものにしてください。"]
      end
    end

    @current_step = if params["current_step"].present?
                      params["current_step"].to_i
                    else
                      1
                    end

    return unless @current_step == TmpMemberInfo::CURRENT_STEP["contract"]

    @incentives = Incentive.where(id: [1, 2])
    @users = User.all
  end

  def confirm
    @current_step = params["current_step"].to_i || 1

    update_tmp_member_info

    if @set_tmp_member_info.valid?
      process_next_step
    else
      handle_invalid_info
    end
  end

  def get_confirm
    @set_tmp_member_info.assign_attributes(session[:tmp_member_info_data])
    @introducer = User.find(@set_tmp_member_info.introducer_id).name
    @saler = User.find(@set_tmp_member_info.sales_id).name
    set_conversion_account_number
  end

  def create
    @set_tmp_member_info.assign_attributes(session[:tmp_member_info_data].merge("approval_id" => "2"))
    set_conversion_account_number
    if @set_tmp_member_info.save
      LineNotifier.notify_tmp_entry(@set_tmp_member_info)
      session[:tmp_member_info_data] = nil
      session[:current_step] = nil
      redirect_to complete_tmp_member_infos_path
    else
      render :new
    end
  end

  def complete; end

  private

  def update_tmp_member_info
    step_mapping = {
      TmpMemberInfo::CURRENT_STEP["base"] => {method: :user_base_info_params, step: "base"},
      TmpMemberInfo::CURRENT_STEP["address"] => {method: :user_address_info_params, step: "address"},
      TmpMemberInfo::CURRENT_STEP["bank"] => {method: :user_bank_info_params, step: "bank"},
      TmpMemberInfo::CURRENT_STEP["contract"] => {method: :user_contract_info_params, step: "contract"}
    }

    if step_mapping[@current_step]
      params_method = step_mapping[@current_step][:method]
      session[:tmp_member_info_data]&.merge!(send(params_method))
      @set_tmp_member_info.assign_attributes(session[:tmp_member_info_data])
      @set_tmp_member_info.current_step = step_mapping[@current_step][:step]
    else
      @set_tmp_member_info.assign_attributes(session[:tmp_member_info_data])
    end
  end

  def process_next_step
    if params["tmp_member_info"]["back_flg"].present?
      @current_step = 5
      flash[:edit] = "修正が完了しました。"
    else
      @current_step += 1
    end

    if @current_step > 4
      redirect_to get_confirm_tmp_member_infos_path
    else
      redirect_to new_tmp_member_info_path(current_step: @current_step)
    end
  end

  def handle_invalid_info
    flash[:error] = @set_tmp_member_info.errors.full_messages
    redirect_to new_tmp_member_info_path(current_step: @current_step)
  end

  def set_tmp_member_info
    @set_tmp_member_info ||= TmpMemberInfo.new
  end

  def user_base_info_params
    params.require(:tmp_member_info).permit(:login_id, :password, :password_confirmation, :name, :name_kana, :email, :phone, :birthday, :gender_id)
  end

  def user_address_info_params
    params.require(:tmp_member_info).permit(:zip_str3, :zip_str4, :ken, :city, :other_address)
  end

  def user_bank_info_params
    params.require(:tmp_member_info).permit(:account_type, :bank_name, :branch_name, :branch_number, :account_number_hash, :account_holder,
                                            :account_number_tail)
  end

  def user_contract_info_params
    params.require(:tmp_member_info).permit(:introducer_id, :sales_id, :incentive_id, :a_san_flg)
  end

  def set_conversion_account_number
    return if @set_tmp_member_info["account_number_hash"].blank?

    @set_tmp_member_info.assign_attributes(account_number_tail: "*****#{@set_tmp_member_info['account_number_hash'][-3..]}")
    @set_tmp_member_info.assign_attributes(account_number_hash: @set_tmp_member_info["account_number_hash"])
  end
end
