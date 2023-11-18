# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :set_page, only: %i(index)

  def index
    @events = Post.order(created_at: :desc)
    @event_infos = Kaminari.paginate_array(@events).page(params[:page]).per(10)
  end

  def show
    @event = Post.find(params[:id])
    @prev_event = Post.where("created_at < ?", @event.created_at).order(created_at: :desc).first
    @next_event = Post.where("created_at > ?", @event.created_at).order(created_at: :asc).first
  end

  private

  def set_page
    session[:events_page] = params[:page] if params[:page].present?
  end
end
