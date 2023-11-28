# frozen_string_literal: true

class IntroducersController < ApplicationController
  before_action :set_search_session, only: %i(index search)

  def index
    @introducers = User.select(:id, :created_at, :name, :status).where(introducer_id: current_user.id).order(id: :asc)
    # 紹介者ごとに紹介したユーザの数を取得
    set_introduced_counts
  end

  def search
    introduce_users = User.select(:id, :created_at, :name, :status).where(introducer_id: current_user.id).order(id: :asc)
    @introducers = introducer_search(introduce_users)
    # 紹介者ごとに紹介したユーザの数を取得
    set_introduced_counts
    set_search_session

    render :index
  end

  private

  def introducer_search introduce_users
    search_params = {
      left_or_right: params[:left_or_right],
      name: params[:name],
      status: params[:status]
    }.compact

    User.introducer_search(search_params, introduce_users)
  end

  def set_introduced_counts
    @introduced_counts = @introducers.each_with_object({}) do |introducer, counts|
      counts[introducer.id] = introducer.introduced_users.count
    end
  end

  def set_search_session
    session[:search_introduce_position] = if params[:left_or_right].present?
                                            valid_position?(params[:left_or_right]) ? params[:left_or_right] : "left"
                                          else
                                            params[:left_or_right]
                                          end
  
    session[:search_introduce_name] = params[:name]
  
    session[:search_introduce_status] = if params[:status].present?
                                          valid_status?(params[:status]) ? params[:status] : 1
                                        else
                                          params[:status]
                                        end
  end  
  
  def valid_position? position
    %w(left right).include?(position)
  end
  
  def valid_status? status
    status.to_i.to_s == status && status.to_i >= 1
  end  
  
end
