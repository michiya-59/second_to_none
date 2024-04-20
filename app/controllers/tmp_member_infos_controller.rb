# frozen_string_literal: true

require "line_notifier"

class TmpMemberInfosController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_tmp_member_info, only: %i(new confirm get_confirm update)
  skip_before_action :authenticate_user, :redirect_not_logged_in, :redirect_not_session

  def new
    @current_step = if params["current_step"].present?
                      params["current_step"].to_i
                    else
                      1
                    end

    @tmp_member_info_id = params[:tmp_member_info_id] if params[:tmp_member_info_id].present?
    return unless @current_step == TmpMemberInfo::CURRENT_STEP["contract"]

    @incentives = Incentive.where(id: [1, 2, 3])
    @users = User.all.order(id: :asc)
  end

  def confirm
    @current_step = params["current_step"].to_i || 1

    tmp_member_info_id = update_tmp_member_info
    return if tmp_member_info_id.nil?

    if @set_tmp_member_info.valid?
      process_next_step tmp_member_info_id
    else
      handle_invalid_info
    end
  end

  def get_confirm
    @tmp_member_info_id = params[:tmp_member_info_id] if params[:tmp_member_info_id].present?
    @introducer = User.find(@set_tmp_member_info.introducer_id).name
    @saler = User.find(@set_tmp_member_info.sales_id).name
    set_conversion_account_number
  end

  def update
    @set_tmp_member_info.assign_attributes("approval_id" => "2")
    set_conversion_account_number
    if @set_tmp_member_info.save
      LineNotifier.notify_tmp_entry(@set_tmp_member_info)
      redirect_to complete_tmp_member_infos_path
    else
      render :new
    end
  end

  def complete; end

  def term_form; end

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
      if send(params_method)["login_id"]
        flash.now[:error] = if validete_uniq? send(params_method)["login_id"], "login_id"
                              ["入力したログインIDは他のユーザ使っています。別のものにしてください。"]
                            end
      end

      if send(params_method)["password"]
        if send(params_method)["password"] == send(params_method)["password_confirmation"]
          flash.now[:error] = nil
        else
          flash.now[:error] = ["パスワードが確認の値と違っています。同じパスワードを入力してください。"]
        end
      end

      @set_tmp_member_info.assign_attributes(send(params_method))
      @set_tmp_member_info.current_step = step_mapping[@current_step][:step]
      if @set_tmp_member_info.valid?
        if @set_tmp_member_info.save
          tmp_member_info_id = @set_tmp_member_info.id
        else
          render :new and return
        end
      else
        if @set_tmp_member_info.errors.full_messages.present?
          flash.now[:error] = @set_tmp_member_info.errors.full_messages
        end
        render :new and return
      end
    end

    render :new and return if flash.now[:error].present?

    tmp_member_info_id
  end

  def process_next_step tmp_member_info_id
    if params["tmp_member_info"]["back_flg"].present?
      @current_step = 5
      flash.now[:edit] = "修正が完了しました。"
    else
      @current_step += 1
    end

    if @current_step > 4
      redirect_to get_confirm_tmp_member_infos_path(tmp_member_info_id:)
    else
      redirect_to new_tmp_member_info_path(current_step: @current_step, tmp_member_info_id:)
    end
  end

  def handle_invalid_info
    flash.now[:error] = @set_tmp_member_info.errors.full_messages
    redirect_to new_tmp_member_info_path(current_step: @current_step) and return
  end

  def set_tmp_member_info
    tmp_member_info_id = if params[:tmp_member_info] && params[:tmp_member_info][:id]
                           params[:tmp_member_info][:id]
                         elsif params[:tmp_member_info_id].present?
                           params[:tmp_member_info_id]
                         end

    @set_tmp_member_info = if tmp_member_info_id
                             TmpMemberInfo.find(tmp_member_info_id)
                           else
                             TmpMemberInfo.new
                           end
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
    params.require(:tmp_member_info).permit(:introducer_id, :sales_id, :incentive_id)
  end

  def set_conversion_account_number
    return if @set_tmp_member_info["account_number_hash"].blank?

    @set_tmp_member_info.assign_attributes(account_number_tail: "*****#{@set_tmp_member_info['account_number_hash'][-3..]}")
    @set_tmp_member_info.assign_attributes(account_number_hash: @set_tmp_member_info["account_number_hash"])
  end
end
