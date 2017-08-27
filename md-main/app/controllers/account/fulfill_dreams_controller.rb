# encoding: utf-8
class Account::FulfillDreamsController < Account::ApplicationController
  def new
    @dream = Dream.new
  end

  def create
    build_dreamer
    if save_dream
      request_accepting
      redirect_to [:success_fulfill, :account, :fulfill_dreams]
    else
      render :new
    end
  end

  def success_fulfill
  end

  private

  def build_dreamer
    @dream ||= Dream.all.build
    @dream.attributes = dream_params
    @dream.dreamer = current_dreamer
    @dream.came_true = true
  end

  def save_dream
    @dream.save
  end

  def request_accepting
    @dream.request_accepting
  end

  def dream_params
    return {} if params[:dream].blank?
    params.require(:dream).permit(:title, :description, :photo, :photo_cache,
                                  :restriction_level, :video, :video_cache, :photo)
  end
end
