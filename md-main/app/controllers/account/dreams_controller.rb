class Account::DreamsController < Account::ApplicationController
  skip_before_filter :authenticate_dreamer!, only: [:index, :show, :friends_dreams]
  before_filter :load_dreamer, only: [:index, :friends_dreams, :suggest, :show_suggested_dreams]

  def sort
    Dream.sort(params[:dream], current_dreamer)
    render nothing: true
  end

  def index
    @dreams = @dreamer.flybook_dreams.
              order(id: :desc).
              page(params[:page]).
              includes(:certificates)

    first_page = 16
    per_page   = 16
    if current_dreamer?(@dreamer)
      first_page -= 1
      if params[:search].blank? && @dreamer.flybook_nb_suggested_dreams > 0
        first_page -= 4
        per_page   -= 4
      end
    end

    @dreams = @dreams.per(@dreams.first_page? ? first_page : per_page)
    @dreams = @dreams.padding(first_page - per_page) if @dreams.current_page > 1

    if request.xhr?
      if params[:paginator]
        render partial: 'account/dreams/index/dreams', layout: false
      else
        render layout: false
      end
    else
      @dreamer.visit!(current_dreamer)

      render layout: 'flybook'
    end
  end

  def friends_dreams
    @dreams = Dreams::FriendsDreamsQuery.call(@dreamer).
              preload(:last_likes, :last_comments).
              page(params[:page]).per(16)

    render 'account/dreams/index', layout: (request.xhr? ? false : 'flybook')
  end

  def new
    build_dream
  end

  def edit
    load_dream
    authorize!(:edit, @dream)
  end

  def show
    load_dream
    @dreamer = @dream.dreamer.decorate
    @dreamers_liked = @dream.liked_dreamers

    @comments = @dream.comments.
                order(id: :desc).
                page(params[:page]).per(10)

    # @previous_dream = @dreamer.flybook_dreams.where("id < ?", params[:id]).first
    # @next_dream = @dreamer.flybook_dreams.where("id > ?", params[:id]).first

    if current_dreamer?(@dreamer)
      @dream.comments.update_all(host_viewed: true)
    end

    @dreamer.visit!(current_dreamer)

    seo_meta(title: @dream.title, description: @dream.description, keywords: '')
    opengraph_meta(@dream)

    render layout: (request.xhr? ? false : 'flybook')
  end

  def create
    dream_form = NewDreamForm.new(dreamer: current_dreamer, params: dream_params)

    if dream_form.save
      @dream = dream_form.dream

      if @dream.taken_from_id.present?
        TakeDream.call(@dream.taken_from, @dream)
      else
        @dream.update_attribute(:suggested_from_id, @dream.id)
      end

      Feed::Activity::Create.call(owner: current_dreamer, trackable: @dream, key: 'dream_create')

      if dream_form.certificate_id.present?
        certificate = Certificate.new(certifiable: @dream,
                                      certificate_type_id: dream_form.certificate_id)
        certificate.save!
        the_redirect_path = belive_in_dream_account_belive_in_dream_index_path
        redirect_to [:certificate_self, :invoices, payable_id: certificate.id,
                                                   payable_type: 'Certificate',
                                                   redirect_path: the_redirect_path]
      else
        redirect_to account_dreamer_dreams_path(current_dreamer)
      end
    else
      @dream = Dream.new(dream_params) # FIXME
      render :new
    end
  end

  def update
    load_dream
    authorize!(:edit, @dream)
    build_dream
    diff = @dream.changes

    if save_dream
      respond_to do |format|
        format.html { render json: diff.to_json }
      end
    else
      respond_to do |format|
        format.html { render json: @dream.errors.to_json }
      end
    end
  end

  def destroy
    load_dream
    authorize!(:edit, @dream)
    if destroy_dream
      redirect_to account_dreamer_dreams_path(current_dreamer)
    end
  end

  # TODO: REFACTOR
  def take
    dream = Dream.find(params[:id])
    taked_dream = Dream.create(
      title: dream.title,
      description: dream.description,
      dreamer: current_dreamer,
      photo: dream.photo,
      taken_from: dream
    )
    Feed::Activity::Create.call(
      owner: current_dreamer,
      trackable: taked_dream,
      key: 'dream_take'
    ) if taked_dream.persisted?
    redirect_to [:account, current_dreamer, :dreams]
  end

  def suggest
    load_dream
    @dream.suggested_dreams.where(receiver: @dreamer).first_or_create
    redirect_to :back
  end

  def suggest_multiple
    load_dream
    # TODO: optimize, need to get array from client
    params[:receiver_id].split(',').each do |id|
      @dream.suggested_dreams.where(receiver_id: id, sender_id: current_dreamer.id).first_or_create
    end
    render json: { success: true }
  end

  def show_suggested_dreams
    @suggested_dreams = @dreamer.suggested_dreams.
                        not_accepted.
                        joins(:dream).
                        merge(Dream.all).
                        preload(dream: { dreamer: :dream_city })

    render partial: 'account/dreams/index/all_suggested_dreams', layout: false
  end

  private

  def load_dream
    load_dreamer
    dream = params[:id].present? ? Dream.find(params[:id]) : Dream.none
    @dream = Dream.all_for(current_dreamer, current_dreamer_id?(dream.try(:dreamer_id))).
             find(params[:id])
    # @dream = @dreamer.flybook_dreams.find(params[:id])

    if dreamer_signed_in?
      @previous = @dreamer.flybook_dreams.where('dreams.id > ?', params[:id]).order(id: :asc).first
      @next = @dreamer.flybook_dreams.where('dreams.id < ?', params[:id]).order(id: :desc).first
    end
  end

  def build_dream
    @dream ||= Dream.new
    @dream.attributes = dream_params
    @dream.fulfilled_at = Time.zone.now if @dream.came_true
    @dream.dreamer = current_dreamer
  end

  def save_dream
    @dream.save
  end

  def destroy_dream
    @dream.destroy if @dream.dreamer == current_dreamer
  end

  def apply_redirect(notice = '')
    redirect_to :back, notice: notice
  end

  def dream_params
    return {} if params[:dream].blank?
    params.require(:dream).permit(:title, :description, :photo, :restriction_level,
                                  :certificate_id, :came_true, :taken_from_id)
  end
end
