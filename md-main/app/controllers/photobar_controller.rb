class PhotobarController < ApplicationController
  before_filter :authenticate_dreamer!

  def add
    if current_dreamer.id == 5280
      render plain: "Лучше найди контакты CTO и пособеседуйся :)"
    else
      current_dreamer.photobar_added_at = Time.now
      current_dreamer.photobar_added_text = params[:photobar_added_text]
      current_dreamer.photobar_added_photo_id = params[:photobar_added_photo_id]
      current_dreamer.save(validates: false)
      render partial: 'application/dreamers_feed/feed_item', locals: {dreamer: current_dreamer}
    end
  end
end
