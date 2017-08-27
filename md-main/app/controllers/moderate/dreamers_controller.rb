class Moderate::DreamersController < Moderate::ApplicationController
  def index
    @dreamers = Dreamer.not_reviewed.active.
                where(project_dreamer: false).
                order(:id).
                page params[:page]
  end

  def show
    @dreamers = Dreamer.where(id: params[:id]).page params[:page]
    render :index
  end

  def block
    approve
    find_dreamer.block!
  end

  def unblock
    approve
    find_dreamer.unblock!
  end

  def search
    @dreamers = Dreamer.ransack(search_hash(dreamer_assoc: false)).
                result.
                page params[:page]
    render :index
  end

  private

  def find_dreamer
    @dreamer = Dreamer.find(params[:id])
  end
end
