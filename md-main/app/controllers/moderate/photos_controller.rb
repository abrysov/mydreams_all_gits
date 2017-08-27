class Moderate::PhotosController < Moderate::ApplicationController
  def index
    @photos = Photo.not_reviewed.
              not_deleted.
              includes(:dreamer).
              where(dreamer: { project_dreamer: false }).
              order(:id).
              page params[:page]
  end

  def show
    @photos = Photo.where(id: params[:id]).page params[:page]
    render :index
  end

  def search
    @photos = Photo.ransack(search_hash).
              result.
              page params[:page]
    render :index
  end
end
