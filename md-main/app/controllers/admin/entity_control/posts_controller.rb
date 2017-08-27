class Admin::EntityControl::PostsController < Admin::EntityControl::ApplicationController
  def index
    @posts = Post.order(:id).
             page params[:page]
  end

  def edit
    @post = find_post
  end

  def show
    @post = find_post
  end

  def update
    @post = find_post
    @post.update(post_params)
    render :show
  end

  def destroy
    Post.where(id: params[:id]).destroy_all
    redirect_to action: :index
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :content)
  end

  def find_post
    Post.find(params[:id])
  end
end
