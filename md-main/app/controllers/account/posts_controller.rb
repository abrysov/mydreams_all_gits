# encoding: utf-8
class Account::PostsController < Account::ApplicationController
  skip_before_filter :authenticate_dreamer!, only: [:index, :show]
  before_filter :load_dreamer, only: [:index, :show, :new, :edit, :suggest, :show_suggested_posts]

  def index
    @posts = post_scope.all_for(current_dreamer, current_dreamer?(@dreamer))

    @posts = @posts.search(params[:posts_search]).
             preload(:last_likes, :last_comments).
             order(id: :desc).
             page(params[:page])

    first_page = 12
    per_page   = 12
    if current_dreamer?(@dreamer)
      first_page -= 1
      if params[:posts_search].blank? && @dreamer.flybook_nb_suggested_posts > 0
        first_page -= 3
        per_page   -= 3
      end
    end

    @posts = @posts.per(@posts.first_page? ? first_page : per_page)
    @posts = @posts.padding(first_page - per_page) if @posts.current_page > 1

    if request.xhr?
      if params[:paginator]
        render partial: 'account/posts/index/posts', layout: false
      else
        render layout: false
      end
    else
      render layout: 'flybook'
    end
  end

  def new
    build_post

    render layout: (request.xhr? ? false : 'flybook')
  end

  def edit
    load_post
  end

  def show
    @post = post_scope.
            all_for(current_dreamer, current_dreamer?(@dreamer)).
            find(params[:id])
    @previous = post_scope.
                all_for(current_dreamer, current_dreamer?(@dreamer)).
                where('posts.id > ?', params[:id]).order(id: :asc).first
    @next = post_scope.
            all_for(current_dreamer, current_dreamer?(@dreamer)).
            where('posts.id < ?', params[:id]).order(id: :desc).first
    @comments = @post.comments.
                order(id: :desc).
                page(params[:page]).per(10)

    @dreamers_liked = @post.liked_dreamers
    if current_dreamer?(@post.dreamer)
      @post.comments.update_all(host_viewed: true)
    end

    seo_meta(title: @post.title, description: @post.description, keywords: '')
    opengraph_meta(@post)

    render layout: (request.xhr? ? false : 'flybook')
  end

  def create
    build_post
    if save_post
      Activity.create(owner: current_dreamer,
                      trackable: @post,
                      key: 'post_create')
      apply_redirect
    else
      render :new
    end
  end

  def update
    load_post
    build_post
    diff = @post.changes

    if save_post
      respond_to do |format|
        format.html { render json: diff.to_json }
      end
    else
      respond_to do |format|
        format.html { render json: @post.errors.to_json }
      end
    end
  end

  def destroy
    load_post
    destroy_post
    apply_redirect
  end

  def suggest
    load_post
    @post.suggested_posts.where(receiver: @dreamer).first_or_create
    Activity.create(owner: current_dreamer,
                    trackable: @post,
                    key: 'post_suggest')
    redirect_to :back
  end

  def suggest_multiple
    load_post
    # TODO: optimize, need to get array from client
    params[:receiver_id].split(',').each do |id|
      @post.suggested_posts.
        where(receiver_id: id, sender_id: current_dreamer.id).
        first_or_create
    end
    Activity.create(owner: current_dreamer,
                    trackable: @post,
                    key: 'post_multiple_suggest')
    render json: { success: true }
  end

  def show_suggested_posts
    @suggested_posts = @dreamer.
                       suggested_posts.
                       not_accepted.
                       joins(:post).
                       merge(Post.all).
                       preload(post: { dreamer: :dream_city })
    render partial: 'account/posts/index/all_suggested_posts', layout: false
  end

  private

  def post_scope
    # if params[:dreamer_id]
    #   load_dreamer
    #   @dreamer.posts.all_for(current_dreamer)
    # elsif dreamer_signed_in?
    #   current_dreamer.posts
    # else
    #   Post.none
    # end
    # current_dreamer.
    # Post.all_for(current_dreamer, true)
    (@dreamer.try(:posts) || Post).not_deleted
  end

  def load_post
    @post ||= post_scope.find(params[:id])
  end

  def build_post
    @post ||= post_scope.build
    @post.attributes = post_params
    @post.dreamer = current_dreamer
  end

  def save_post
    @post.save
  end

  def destroy_post
    @post.destroy
  end

  def apply_redirect(notice = '')
    redirect_to [:account, current_dreamer, :posts]
  end

  def post_params
    return {} if params[:post].blank?
    params.require(:post).permit(:title, :body, :photo, :restriction_level)
  end
end
