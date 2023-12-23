# frozen_string_literal: true

class HomesController < ApplicationController
  def index
    @user = User.find(current_user.id)
  end
end
