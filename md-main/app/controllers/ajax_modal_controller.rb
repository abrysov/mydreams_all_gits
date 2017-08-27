class AjaxModalController < ApplicationController
  before_filter :load_dreamer, except: :search
  before_filter :redirect_unless_sign_in,
                only: %i(add_to_feed unviewed_news avatar update_dreambook_bg)

  def authorization
    render partial: 'ajax_modal/form_authorization', locals: {dreamer: @dreamer, resource_name: @resource_name, resource_class: @resource_class}
  end

  def registration
    render partial: 'ajax_modal/form_registration',
      locals: {
        dreamer: DreamerDecorator.decorate(Dreamer.new),
        resource_name: @resource_name,
        resource_class: @resource_class
      }
  end

  def edit_profile
    render partial: 'ajax_modal/form_edit', locals: {dreamer: @dreamer, resource_name: @resource_name, resource_class: @resource_class}
  end

  def new_password
    render partial: 'devise/passwords/new', locals: {resource: @dreamer, resource_name: @resource_name, resource_class: @resource_class}
  end

  def edit_password
    render partial: 'devise/passwords/edit', locals: {resource: @dreamer, resource_name: @resource_name, resource_class: @resource_class}
  end

  def search
    render partial: 'ajax_modal/form_search'
  end

  def suggest_dream
    @dream = request_entity_object
    build_suggested_dream

    render partial: 'ajax_modal/form_suggest_dream', locals: {dream: @dream, dreamer: @dreamer, suggested_dream: @suggested_dream}
  end

  def suggest_post
    @post = request_entity_object
    build_suggested_post

    render partial: 'ajax_modal/form_suggest_post', locals: {post: @post, dreamer: @dreamer, suggested_post: @suggested_post}
  end

  def commentators
    @comments = request_entity_object.comments.page(params[:page]).per(10)
    render partial: 'ajax_modal/modal_commentators', locals: {comments: @comments, entity_type: params[:entity_type], entity_id: params[:entity_id]}
  end

  def liked_list
    liked_dreamers = request_entity_object.liked_dreamers.page(params[:page]).per(10)
    @liked_dreamers = DreamerDecorator.decorate_collection liked_dreamers
    render partial: 'ajax_modal/modal_liked_dreamers', locals: {liked_dreamers: @liked_dreamers, entity_type: params[:entity_type], entity_id: params[:entity_id]}
  end

  def certificates
    @dream = request_entity_object
    @certificates = @dream.certificates.paid.page(params[:page]).per(9)

    if params[:page]
      if @certificates.total_pages >= @certificates.current_page
        render partial: 'ajax_modal/modal_certificates/certificates', locals: {certificates: @certificates, dream: @dream}
      elsif @certificates.total_pages < @certificates.current_page
        render json: {last_page: true}
      end
    else
      render partial: 'ajax_modal/modal_certificates', locals: {certificates: @certificates, dream: @dream}
    end
  end

  def buy_certificates
    @dream = request_entity_object
    build_certificates

    @dreamer = current_dreamer
    render partial: 'ajax_modal/modal_buy_certificates', locals: {certificate: @certificate, dreamer: @dreamer, dream: @dream}
  end

  def take_dream
    @dream = request_entity_object
    build_dream

    if @dream.photo.file.present? && @dream.photo.file.exists?
      @photo = Base64.strict_encode64 @dream.photo.file.read
    end

    render partial: 'ajax_modal/form_take_dream',
      locals: { dream: @dream, new_dream: @new_dream, photo: @photo }
  end

  def take_post
    @post = request_entity_object
    build_post

    if @post.photo.file.present? && @post.photo.file.exists?
      @photo = Base64.strict_encode64 @post.photo.file.read
    end

    render partial: 'ajax_modal/form_take_post',
      locals: {post: @post, new_post: @new_post, photo: @photo}
  end

  def set_private
    @dream = request_entity_object
    render partial: 'ajax_modal/form_set_private', locals: {dream: @dream}
  end

  def avatar
    render partial: 'ajax_modal/form_avatar', locals: {dreamer: current_dreamer}
  end

  def send_msg
    @dreamer = Dreamer.find(params[:dreamer_id])
    build_message
    render partial: 'ajax_modal/form_send_message', locals: {dreamer: @dreamer, message: @message}
  end

  def share
    @object = request_entity_object
    render partial: 'ajax_modal/modal_share', locals: {object: @object}
  end

  def fulfill_dream
    @dream = request_entity_object
    render partial: 'ajax_modal/modal_fulfill_dream', locals: {dream: @dream}
  end

  def create_fulfilled_dream
    build_dream

    render partial: 'ajax_modal/form_fulfilled_dream', locals: {new_dream: @new_dream}
  end

  def bad_image
    @height = params[:min_height]
    @width = params[:min_width]
    render partial: 'ajax_modal/modal_bad_image', locals: {height: @height, width: @width}
  end

  def add_to_feed
    @photos = current_dreamer.photos
    render partial: 'ajax_modal/form_add_to_feed', locals: {dreamer: current_dreamer, photos: @photos}
  end

  def update_dreambook_bg
    render partial: 'ajax_modal/form_dreambook_bg', locals: {dreamer: current_dreamer}
  end

  def unviewed_news
    @posts = current_dreamer.unviewed_news
    render partial: 'unviewed_news'
    current_dreamer.update_last_viewed_news_time
  end

  private
    # DREAMER
    def load_dreamer
      @dreamer ||= current_dreamer || Dreamer.new
    end

    def build_dream
      @new_dream ||= Dream.new
      @new_dream.attributes = dream_params
      @new_dream.dreamer = current_dreamer
    end

    def dream_params
      return {} if params[:dream].blank?
      params.require(:dream).permit(:title, :description, :photo, :restriction_level, :certificate_id, :came_true)
    end

    def build_suggested_dream
      @suggested_dream ||= SuggestedDream.new
      @suggested_dream.attributes = suggested_dream_params
    end

    def suggested_dream_params
      return {} if params[:suggested_dream].blank?
      params.require(:suggested_dream).permit(:dream_id, :receiver_id, :accepted)
    end

    # MESSAGE
    def build_message
      @message = Message.new(message_params)
      @message.sender = current_dreamer
      @message.receiver = @dreamer
    end

    def message_params
      return {} if params[:message].blank?
      params.require(:message).permit(:message)
    end

    # CERTIFICATES
    def build_certificates
      @certificate ||= Certificate.new
      @certificate.attributes = certificate_params
    end

    def certificate_params
      return {} if params[:certificate].blank?
      params.require(:certificate).permit(:certificate_type_id, :certifiable_id, :gifted_by_id)
    end

    def build_post
      @new_post ||= Post.new
      @new_post.attributes = post_params
      @new_post.dreamer = current_dreamer
    end

    def post_params
      return {} if params[:post].blank?
      params.require(:post).permit(:title, :body, :photo)
    end

    def build_suggested_post
      @suggested_post ||= SuggestedPost.new
      @suggested_post.attributes = suggested_post_params
    end

    def redirect_unless_sign_in
      redirect_to modal_authorization_path unless current_dreamer
    end

    def suggested_post_params
      return {} if params[:suggested_post].blank?
      params.require(:suggested_post).permit(:post_id, :receiver_id, :accepted)
    end
end
