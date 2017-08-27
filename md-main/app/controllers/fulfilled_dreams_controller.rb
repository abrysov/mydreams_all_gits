class FulfilledDreamsController < ApplicationController
  def index
    @fulfilled_dreams = Dreams::DreamsFinder.new.
                        filter(params.merge(fulfilled: true), current_dreamer).
                        page(params[:page]) #.includes(:certificates, :last_likes, :last_comments)

    first_page = 15
    per_page   = 16

    @fulfilled_dreams = @fulfilled_dreams.per(@fulfilled_dreams.first_page? ? first_page : per_page)
    @fulfilled_dreams = @fulfilled_dreams.padding(first_page - per_page) if @fulfilled_dreams.current_page > 1

    if request.xhr?
      render partial: 'fulfilled_dreams/index'
    end
  end

  def show
    @fulfilled_dream = Dream.came_true.find(params[:id])
  end
end
