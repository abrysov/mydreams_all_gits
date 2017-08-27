class PostsController < ApplicationController
  def index
    scope = project_dreamer.posts.not_deleted.
            order(created_at: :desc)

    @posts = if params[:from].present?
      scope.where('posts.id < ?', params[:from].to_i).limit(5)
    else
      scope
    end

    respond_to do |format|
      format.js   { render 'more_posts' }
    end
  end

  private

  def project_dreamer
    Dreamer.project_dreamer || Dreamer.first
  end
end
