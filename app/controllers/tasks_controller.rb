# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :task_load_data
  def index; end

  def new
    @task = Task.new
    case params[:type]
    when "new_mt"
      @title_label_name = "新規MT"
    when "stock"
      @title_label_name = "株式取引の学び"
    when "insurance"
      @title_label_name = "保険の学び"
    when "real_estate"
      @title_label_name = "不動産の学び"
    when "nisa"
      @title_label_name = "NISAの学び"
    when "derivative"
      @title_label_name = "為替取引"
    end
  end

  def create
    @task = Task.new(task_params)
    @task.assign_attributes(user_id: current_user&.id)

    # 重複チェック
    existing_task = Task.find_by(user_id: current_user&.id, learn_id: @task.learn_id)
    if existing_task
      flash[:error] = "すでに同じ課題が登録されています。"
      redirect_to new_task_path(type: params[:task][:type])
    elsif @task.save
      flash[:success] = "課題が提出されました。"
      redirect_to new_task_path(type: params[:task][:type])
    else
      render :new
    end
  end

  def confirm
    @user_all = User.select(:id, :name).all

    if params[:id].blank? && params[:learn_id].present?
      @tasks = Task.includes(:user).where(learn_id: params[:learn_id], approved: false)
    elsif params[:id].present? && params[:learn_id].present? && params[:approved]
      approved = ActiveRecord::Type::Boolean.new.cast(params[:approved])
      @task = Task.includes(:user).find_by(learn_id: params[:learn_id], user_id: params[:id], approved:)
    elsif params[:id].present? && params[:learn_id].present?
      @task = Task.includes(:user).find_by(learn_id: params[:learn_id], user_id: params[:id], approved: false)
    end
    @learn = Learn.select(:name).find(params[:learn_id])
  end

  def member_detail
    @task = Task.with_attached_files.find(params[:id])
  end

  def submitted
    @learn_category_info = LearnCategory.find(params[:id])

    learn_id_list = Learn.where(learn_category_id: params[:id])
    @my_tasks = Task.where(user_id: current_user.id, learn_id: learn_id_list).order(learn_id: :asc)
  end

  def update
    tasks = Task.find(params[:id])
    approved = params[:task][:approved].to_i == 1

    if tasks.update(approved:)
      flash[:success] = "承認済にしました。"
      redirect_to member_detail_task_path(tasks, type: params[:task][:type])
    else
      render :edit
    end
  end

  private

  def task_params
    params.require(:task).permit(:learn_category_id, :learn_id, :comment, files: [])
  end

  def task_load_data
    current_user_id = current_user.id # 現在のユーザーIDを取得

    case params[:type]
    when "new_mt"
      @learn_category_id = 1
    when "stock"
      @learn_category_id = 2
    when "insurance"
      @learn_category_id = 3
    when "real_estate"
      @learn_category_id = 4
    when "nisa"
      @learn_category_id = 5
    when "derivative"
      @learn_category_id = 6
    end

    # 指定されたlearn_category_idに基づいてLearnのレコードを取得し、
    # さらに現在のユーザーに紐づくTaskがないもののみを選択
    @learns = Learn.select(:name, :id)
      .where(learn_category_id: @learn_category_id)
      .where.not(
        id: Task.select(:learn_id)
                .where(user_id: current_user_id)
      )
  end
end
