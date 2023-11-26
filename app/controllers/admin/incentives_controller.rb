# frozen_string_literal: true

module Admin
  class IncentivesController < ApplicationController
    def index
      @incentives = Incentive.order(id: :asc)
    end

    def edit
      @incentive = Incentive.find(params[:id])
    end

    def update
      @incentive = Incentive.find(params[:id])
      if @incentive.update(incentive_params)
        flash[:success] = "報酬情報の更新が完了しました。"
        redirect_to admin_incentives_path
      else
        render :edit
      end
    end

    private 
    
    def incentive_params
      params.require(:incentive).permit(:course_name, :incentive_price)
    end
  end
end
