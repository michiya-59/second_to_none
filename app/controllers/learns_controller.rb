# frozen_string_literal: true

class LearnsController < ApplicationController
  before_action :get_learn_category, only: %i(index learn_list)
  def index; end

  def learn_list 
    @learns = Learn.where(learn_category_id: params[:id])
    @learn_infos = Kaminari.paginate_array(@learns).page(params[:page]).per(3)
    @learn_category_name = LearnCategory.find(params[:id]).name
  end

  private

  def get_learn_category
    @learn_category = LearnCategory.all
  end
end
