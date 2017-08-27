class Moderate::CommentsController < Moderate::ApplicationController
  def index
    @comments = Comment.not_reviewed.
                not_deleted.
                includes(:dreamer).
                where(dreamer: { project_dreamer: false }).
                order(:id).
                page params[:page]
  end

  def show
    @comments = Comment.where(id: params[:id]).page params[:page]
    render :index
  end

  def search
    @comments = Comment.ransack(search_hash).
                result.
                page params[:page]
    render :index
  end
end
