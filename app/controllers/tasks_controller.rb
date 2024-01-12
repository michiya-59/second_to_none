# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :task_load_data
  def index; end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    @task.assign_attributes(user_id: current_user.id)

    # 重複チェック
    existing_task = Task.find_by(user_id: current_user.id, learn_id: @task.learn_id)
    if existing_task
      flash[:error] = "すでに同じ課題が登録されています。"
      redirect_to new_task_path
    elsif @task.save
      flash[:success] = "課題が提出されました。"
      redirect_to new_task_path
    else
      render :new
    end
  end

  def confirm
    @user_all = User.select(:id, :name).all

    if params[:id].blank? && params[:learn_id].present?
      @tasks = Task.includes(:user).where(learn_id: params[:learn_id])
    elsif params[:id].present? && params[:learn_id].present?
      @task = Task.includes(:user).find_by(learn_id: params[:learn_id], user_id: params[:id])
    end
    @learn = Learn.select(:name).find(params[:learn_id])
  end

  def member_detail
    @task = Task.with_attached_files.find(params[:id])
  end

  private

  def task_params
    params.require(:task).permit(:learn_id, :comment, files: [])
  end

  def task_load_data
    @learns = Learn.select(:name, :id).all
  end
end
