class SearchController < ApplicationController
  def index
    search_types = params[:search_type] ? [params[:search_type]] : %w(dreams dreamers posts)
    search_types.each do |type|
      @results = find_collection(type)
      @results = @results.page(params[:page]).per(type == 'posts' ? 12 : 16)
      @type = type

      break if @results.total_count > 0
    end

    if request.xhr?
      render partial: 'search/search_results', layout: false
    end
  end

  private

  def find_collection(search_type)
    case search_type
    when 'dreamers'
      Dreamer.where.not(project_dreamer: true).
        search(first_name_or_last_name_or_status_cont_any: params[:search]).
        result
    when 'posts'
      Post.all_for(current_dreamer, false).search(params[:search])
    else
      Dreams::DreamsFinder.new.filter(params, current_dreamer, false)
    end
  end
end
