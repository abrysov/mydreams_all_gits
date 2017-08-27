class Moderate::PostsController < Moderate::ApplicationController
  def index
    @posts = Post.not_reviewed.
             includes(:dreamer).
             where(dreamer: { project_dreamer: false }).
             order(:id).
             page params[:page]
  end

  def show
    @posts = Post.where(id: params[:id]).page params[:page]
    render :index
  end

  def search
    @posts = Post.ransack(search_hash).
             result.
             page params[:page]
    render :index
  end
end
