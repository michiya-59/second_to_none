class TmpMemberInfosController < ApplicationController
  before_action :set_session_info, only: %i[new]
  before_action :set_tmp_member_info, only: %i[new confirm get_confirm create]

  def new
    session[:tmp_member_info_data] ||= {}

    if params["current_step"].present?
      @current_step = params["current_step"].to_i
    else
      @current_step = 1
    end

    if @current_step == TmpMemberInfo::CURRENT_STEP["contract"]
      @incentives = Incentive.where(id: [1, 2])
      @users = User.all
    end
  end

  def confirm
    @current_step = params["current_step"].to_i || 1
    if @current_step == TmpMemberInfo::CURRENT_STEP["base"]
      session[:tmp_member_info_data].merge!(user_base_info_params)
      @tmp_member_info.assign_attributes(session[:tmp_member_info_data])
      @tmp_member_info.current_step = 'base'
    elsif @current_step == TmpMemberInfo::CURRENT_STEP["address"]
      session[:tmp_member_info_data].merge!(user_address_info_params)
      @tmp_member_info.assign_attributes(session[:tmp_member_info_data])
      @tmp_member_info.current_step = 'address'
    elsif @current_step == TmpMemberInfo::CURRENT_STEP["bank"]
      session[:tmp_member_info_data].merge!(user_bank_info_params)
      @tmp_member_info.assign_attributes(session[:tmp_member_info_data])
      @tmp_member_info.current_step = 'bank'
    elsif @current_step == TmpMemberInfo::CURRENT_STEP["contract"]
      session[:tmp_member_info_data].merge!(user_contract_info_params)
      @tmp_member_info.assign_attributes(session[:tmp_member_info_data])
      @tmp_member_info.current_step = 'contract'
    else
      @tmp_member_info.assign_attributes(session[:tmp_member_info_data])
    end
    
    if @tmp_member_info.valid?
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
    else
      flash[:error] = @tmp_member_info.errors.full_messages
      redirect_to new_tmp_member_info_path(current_step: @current_step)
    end
  end

  def get_confirm
    @tmp_member_info.assign_attributes(session[:tmp_member_info_data])
    set_conversion_account_number    
  end

  def create
    @tmp_member_info.assign_attributes(session[:tmp_member_info_data].merge("approval_id" => "2"))
    set_conversion_account_number
    if @tmp_member_info.save
      session[:tmp_member_info_data] = nil
      session[:current_step] = nil
      redirect_to complete_tmp_member_infos_path
    else
      render :new
    end
  end
  
  def complete
  end

  private

  def set_tmp_member_info
    @tmp_member_info ||= TmpMemberInfo.new
  end

  def set_session_info
  end

  def user_base_info_params
    params.require(:tmp_member_info).permit(:login_id, :password, :password_confirmation, :name, :name_kana, :email, :phone, :birthday, :gender_id)
  end

  def user_address_info_params
    params.require(:tmp_member_info).permit(:zip_str3, :zip_str4, :ken, :city, :other_address)
  end

  def user_bank_info_params
    params.require(:tmp_member_info).permit(:account_type, :bank_name, :branch_name, :branch_number, :account_number_hash, :account_holder, :account_number_tail)
  end

  def user_contract_info_params
    params.require(:tmp_member_info).permit(:introducer_id, :sales_id, :incentive_id, :left_or_right, :a_san_flg)
  end

  def set_conversion_account_number
    if @tmp_member_info["account_number_hash"].present?
      @tmp_member_info.assign_attributes(account_number_tail: "*****" + @tmp_member_info["account_number_hash"][-3..])
      @tmp_member_info.assign_attributes(account_number_hash: "********")
    end
  end

end
