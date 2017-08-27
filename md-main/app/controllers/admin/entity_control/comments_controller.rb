class Admin::EntityControl::CommentsController < Admin::EntityControl::ApplicationController
  def index
    @comments = Comment.order(:id).
                page params[:page]
  end

  def edit
    @comment = find_comment
  end

  def show
    @comment = find_comment
  end

  def update
    @comment = find_comment
    @comment.update(comment_params)
    render :show
  end

  def destroy
    Comment.where(id: params[:id]).destroy_all
    redirect_to action: :index
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def find_comment
    Comment.find(params[:id])
  end
end
