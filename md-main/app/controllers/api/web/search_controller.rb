class Api::Web::SearchController < Api::Web::ApplicationController
  def index
    collections = PgSearch.multisearch(params[:q]).
                  includes(:searchable).
                  page(page).
                  per(per_page)

    meta = { meta: { status: 'success', code: 200 }.merge(pagination_meta_for(collections)) }
    render json: json_from_collections(collections).merge(meta),
           status: :ok
  end

  private

  def initial_json
    {}.tap do |hash|
      %w(dreams dreamers posts).each do |type|
        hash[type] = []
      end
    end
  end

  def json_from_collections(collections)
    json = initial_json
    collections.map(&:searchable).each do |obj|
      json['dreams'] << DreamSerializer.new(obj).as_json           if obj.is_a?(Dream)
      json['dreamers'] << ShortDreamerSerializer.new(obj).as_json  if obj.is_a?(Dreamer)
      json['posts'] << PostSerializer.new(obj).as_json             if obj.is_a?(Post)
    end
    json
  end
end
