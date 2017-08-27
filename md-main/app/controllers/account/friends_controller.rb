class Account::FriendsController < Account::ApplicationController
  skip_before_filter :authenticate_dreamer!, only: [:index]

  def index
    respond_to do |format|
      format.html do
        per_page = params[:search].blank? && current_dreamer?(@dreamer) && @dreamer.flybook_nb_received_friends > 0 ? 12 : 16

        @dreamer = Dreamer.find(params[:dreamer_id]).decorate
        @friends = Dreamers::DreamersFinder.new(@dreamer.latest_friends).
                   filter(params).
                   page(params[:page]).
                   per(per_page).
                   includes(:dream_city)

        if request.xhr?
          if params[:paginator]
            render partial: 'account/friends/friends', layout: false
          else
            render layout: false
          end
        else
          render layout: 'flybook'
        end
      end

      format.json do
        render json: friend_scope.to_json(only: [:id], methods: [:truncate_full_name, :avatar_url_or_default_medium])
      end
    end
  end

  def search
    @dreamer = current_dreamer
    @friends = friend_scope

    if params[:term][:term]
      @target_friends = @friends.where('first_name ILIKE :q OR last_name ILIKE :q', q: "%#{params[:term][:term]}%").select('dreamers.id,first_name,last_name,gender,avatar')
      @friend_list = @target_friends.map do |f|
        { id: f.id, first_name: f.first_name, last_name: f.last_name, avatar: avatar_or_default(f, :small) }
      end
    end

    respond_to do |format|
      format.json{ render json: @friend_list }
    end
  end

  def show_received_friends
    @dreamer = Dreamer.find params[:dreamer_id]
    @received_friends = @dreamer.friend_applicants

    render partial: 'account/friends/index/all_received_friends', layout: false
  end

  private

  def friend_scope
    @dreamer.friends
  end

  def apply_redirect(notice = '')
    redirect_to account_friends_path, notice: notice
  end

  def friend_params
    return {} if params[:friend].blank?
    params.require(:friend).permit(:dreamer_id, :friend_id)
  end
end
