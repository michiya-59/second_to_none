# frozen_string_literal: true

class LearnsController < ApplicationController
  before_action :get_learn_category, only: %i(index learn_list)
  def index; end

  def learn_list
    if params && params["type"] == "新規MT"
      @learns = Learn.where(learn_category_id: 1)
      @learn_category_name = LearnCategory.find(1).name
    else
      @learns = Learn.where(learn_category_id: params[:id])
      @learn_category_name = LearnCategory.find(params[:id]).name
    end
    @learn_infos = Kaminari.paginate_array(@learns).page(params[:page]).per(6)
  end

  private

  def get_learn_category
    @learn_category = LearnCategory.where.not(id: [1, params[:id]])
  end
end
