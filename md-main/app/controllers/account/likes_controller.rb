class Account::LikesController < Account::ApplicationController
  def like
    likeable = request_entity_object
    unless Like.exists?(dreamer: current_dreamer, likeable: likeable)
      like = Like.create(dreamer: current_dreamer, likeable: likeable)
      if like.persisted? &&
         [Dream, Post].member?(request_entity_object.class) &&
         likeable.suggested_from_id.nil?

        Feed::Activity::Create.call(
          owner: current_dreamer,
          trackable: likeable,
          key: likeable.class.to_s.downcase + '_like'
        )
      end
    end

    respond_for_action
  end

  def unlike
    likeable = request_entity_object
    if Like.exists?(dreamer: current_dreamer, likeable: likeable)
      Activity.where(
        owner: current_dreamer,
        trackable: likeable,
        key: likeable.class.to_s.downcase + '_like'
      ).destroy_all

      Like.delete_all(dreamer: current_dreamer, likeable: likeable)
      # приходится вызывать вручную, т.к. для топ-дримсов работает некорретно (default_scope is evil!!!)
      likeable.class.update_counters(likeable.id, [[:likes_count, -1]])
    end

    respond_for_action
  end

  def liked
    respond_with_liked
  end

  private

  def respond_with_liked
    liked_dreamers = request_entity_object.liked_dreamers.page(params[:page]).per(10)
    last_page = {last_page: true}.to_json

    if liked_dreamers.total_pages >= liked_dreamers.current_page
      render partial: 'ajax_modal/modal_liked_dreamers/liked_dreamers', locals: {liked_dreamers: liked_dreamers}
    elsif liked_dreamers.total_pages < liked_dreamers.current_page
      render json: last_page
    end
  end

  def respond_for_action
    nb_likes    = request_entity_object.likes.count

    last_likes = Like.where(likeable: request_entity_object).
                 order(id: :desc).
                 limit(5).
                 preload(dreamer: [:dream_country, :dream_city])

    like_action = request_entity_object.liked_by?(current_dreamer) ? 'like' : 'unlike'

    respond_to do |format|
      format.json  {
        render json: {
          all_liked: nb_likes,
          liked_title: "#{nb_likes} #{custom_pluralize(nb_likes, 'liked_dreamers')}",
          liked_action: t("actions.#{like_action}"),
          liked_dreamers: last_likes.map(&:dreamer).to_json(only: [:id, :first_name, :last_name], methods: [:avatar_url_or_default_small, :city_name, :country_name, :age])
        }
      }
    end
  end
end
