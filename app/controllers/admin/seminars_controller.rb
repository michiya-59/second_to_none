# frozen_string_literal: true

module Admin
  class SeminarsController < ApplicationController
    before_action :seminar_load_data, only: %i(index new edit update)

    def index
      @admin_seminar = Seminar.new
      @search_year, @search_month = set_search_date params
    end

    def new; end

    def edit; end

    def create
      @admin_seminar = Seminar.new(seminars_params)
      @admin_seminar = convert_datatime params, @admin_seminar
      if @admin_seminar.save
        flash[:success] = "セミナー情報の作成が完了しました。"
      else
        flash[:form_error] = @admin_seminar.errors.full_messages
      end
      redirect_to admin_seminars_path
    end

    def update
      @seminar = convert_datatime params, @seminar

      if @seminar.update(seminars_params)
        flash[:success] = "セミナー情報の更新が完了しました。"
        redirect_to admin_seminars_path
      else
        flash[:form_error] = @seminar.errors.full_messages
        redirect_to edit_admin_seminar_path(params[:id])
      end
    end

    def destroy
      @seminar = Seminar.find(params[:id])
      if @seminar.destroy
        flash[:delete_success] = "セミナー情報が削除されました。"
      else
        flash[:error] = "セミナー情報の削除に失敗しました。"
      end
      redirect_to admin_seminars_path
    end

    private

    def seminar_load_data
      @seminar = params[:id].present? ? Seminar.find(params[:id]) : Seminar.new

      @seminar_infos = if params[:search_year].present? && params[:search_month].present?
                         Seminar.search_by_year_and_month(params[:search_year].to_i, params[:search_month].to_i)
                       else
                         Seminar.find_seminars
                       end

      @seminar_infos = Kaminari.paginate_array(@seminar_infos).page(params[:page]).per(10)
    end

    def seminars_params
      params.require(:seminar).permit(:title, :year, :month, :day, :start_time, :end_time, :teacher)
    end

    def convert_datatime params, seminar_info
      if params[:seminar].present? && (params[:seminar][:year].present? && params[:seminar][:month].present? && params[:seminar][:day].present?)
        seminar_info.year = params[:seminar][:year].to_i
        seminar_info.month = params[:seminar][:month].to_i
        seminar_info.day = params[:seminar][:day].to_i
      end
      seminar_info
    end

    def set_search_date params
      if params[:search_year].present?
        search_year = params[:search_year]
        search_month = params[:search_month]
      else
        search_year = Time.zone.today.year
        search_month = Time.zone.today.month
      end
      [search_year, search_month]
    end
  end
end
