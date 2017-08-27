class WelcomeController < ApplicationController
  def index
    if dreamer_signed_in? && for_new_design?
      return redirect_to feed_path
    end

    @project_dreamer = if Rails.env.production?
                         Dreamer.find(1)
                       else
                         Dreamer.project_dreamer || Dreamer.first
                       end
    @news = @project_dreamer.posts.order(created_at: :desc).limit(5)
    @celebrities = Dreamer.celebrities.includes(:dream_country, :dream_city).where.not(avatar: nil).order("RANDOM()").limit(7)

    if @feed = dreamer_signed_in?
      current_dreamer.update_last_viewed_news_time
      render 'feed'
    else
      render 'index'
    end
  end
end
