# frozen_string_literal: true

class ConnectServicesController < ApplicationController
  def index; end

  def new
    @contact = Contact.new
    @service_name = get_connect_service_title params[:type]
  end

  def create
    @contact = Contact.new(contact_params)
    contact_message = {
      name: @contact&.name,
      email: @contact&.email,
      message: @contact&.message,
      service_name: params[:contact][:type_name] || "なし"
    }

    if @contact.save
      LineNotifier.notify_service_contact(contact_message)
      flash[:success] = 'お問い合わせありがとうございます！<br>担当者より追ってメールアドレス、または直接ご連絡いたします。'
      redirect_to new_connect_service_path(type: params[:contact][:type])
    else
      render :new
    end
  end

  def whitening; end

  def photography; end

  def movie_edit; end

  def web_site_creation; end

  def rent; end

  def moving; end

  def beauty_clinic; end

  def hair_removal_medical; end

  def hair_removal_beauty; end

  def personal_color; end

  def job_change_agent; end

  def mobile_communicating_charge_rethink; end

  private

  def contact_params
    params.require(:contact).permit(:name, :message, :email)
  end

  def get_connect_service_title type_name
    case type_name
    when "beauty_clinic"
      name = "美容クリニック"
    when "hair_removal_beauty"
      name = "脱毛【美容】"
    when "hair_removal_medical"
      name = "脱毛【医療】"
    when "job_change_agent"
      name = "転職エージェント"
    when "mobile_communicating_charge_rethink"
      name = "携帯通信料見直し"
    when "movie_edit"
      name = "動画編集依頼"
    when "moving"
      name = "引越し"
    when "personal_color"
      name = "パーソナルカラー"
    when "photography"
      name = "写真撮影"
    when "rent"
      name = "賃貸"
    when "web_site_creation"
      name = "ホームページ作成依頼"
    when "whitening"
      name = "ホワイトニング"
    else
      name = "連携先"
    end
    name
  end
end
