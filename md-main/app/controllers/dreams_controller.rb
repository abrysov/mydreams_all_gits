class DreamsController < ApplicationController
  def index
    unless for_new_design?
      return top if params[:top].present?

      @dreams = Dreams::DreamsFinder.new.
                filter(params, current_dreamer, true).
                page(params[:page]).
                per(16).
                preload(:certificates, :dreamer, :last_likes, :last_comments)

      if request.xhr?
        render partial: 'dreams/dreams'
      end
    end
  end

  def top
    @dreams = TopDream.most_liked.by_locale.page(params[:page]).per(16).
              preload(:last_likes, :last_comments)

    if request.xhr?
      render partial: 'top/dreams/dreams'
    else
      render 'top/dreams/index'
    end
  end

  def show
    unless for_new_design?
      @dream = TopDream.find_by(id: params[:id]) ||
               Dream.all_for(current_dreamer).find_by(id: params[:id])
      # TODO: ???
      if @dream
        @comments = @dream.comments.joins(:dreamer).page(1).per(10).order(id: :desc)
      else
        redirect_to root_path
      end

      render 'top/dreams/show' if @dream.instance_of? TopDream
    end
  end
end
