class CommentsController < ApplicationController
  def index
    scope = request_entity_object.comments.preload(:dreamer).order(id: :desc)

    comments = if params[:from].present?
                 scope.where('id < ?', params[:from].to_i)
               else
                 scope.page(params[:page]).per(10)
               end

    if request.xhr?
      if params[:show_page]
        render partial: 'comments/comments', layout: false,
               locals: { comments: comments, object: request_entity_object }
      elsif params[:from]
        render json: comments, each_serializer: CommentSerializer
      elsif comments.total_pages >= comments.current_page
        render partial: 'ajax_modal/modal_commentators/commentators', locals: { comments: comments }
      else
        render json: { last_page: true }
      end
    end
  end

  def create
    commentable = request_entity_object
    comment = Comment.create(
      dreamer: current_dreamer,
      commentable: commentable,
      body: params[:body] || comment_params[:body]
    )

    if comment.persisted?
      if params[:files]
        params[:files].each do |file_param|
          comment.attachments.build(file: file_param).save
        end
      end

      if %w{dream post}.include?(params[:entity_type])
        Activity.create(
          owner: current_dreamer,
          trackable: commentable,
          key: "#{params[:entity_type]}_create"
        )
      end
      respond_to do |format|
        format.html { render partial: 'comments/comment', layout: false, object: comment }
        format.js { render json: comment, serializer: CommentSerializer }
      end
    else
      render json: { errors: 1 }
    end
  end

  def update
    @comment = Comment.find params[:id]
    authorize! :edit, @comment
    build_comment

    if @comment.save
      render partial: 'comments/comment', layout: false, object: @comment
    else
      render json: { errors: 1 }
    end
  end

  def destroy
    @comment = Comment.find params[:id]
    authorize! :delete, @comment
    @comment.destroy

    render json: { errors: 0 }
  end

  private

  def build_comment
    @comment ||= Comment.build
    @comment.attributes = comment_params
  end

  def comment_params
    return {} if params[:comment].blank?
    params.require(:comment).permit(:body)
  end
end
