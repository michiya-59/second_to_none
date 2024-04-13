# frozen_string_literal: true

class HomesController < ApplicationController
  def index
    @user = User.find(current_user&.id)
  end

  def get_entry_url; end

  def term; end
end
