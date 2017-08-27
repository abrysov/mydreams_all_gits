class Moderate::DreamsController < Moderate::ApplicationController
  def index
    @dreams = Dream.not_reviewed.
              not_deleted.
              includes(:dreamer).
              where(dreamer: { project_dreamer: false }).
              page params[:page]
  end

  def show
    @dreams = Dream.where(id: params[:id]).page params[:page]
    render :index
  end

  def search
    @dreams = Dream.ransack(search_hash).
              result.
              page params[:page]
    render :index
  end
end
