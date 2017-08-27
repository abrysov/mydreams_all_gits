class Admin::EntityControl::DreamsController < Admin::EntityControl::ApplicationController
  def index
    @dreams = Dream.order(:id).
              page params[:page]
  end

  def edit
    @dream = find_dream
  end

  def show
    @dream = find_dream
  end

  def update
    @dream = find_dream
    @dream.update(dream_params)
    render :show
  end

  def destroy
    Dream.where(id: params[:id]).destroy_all
    redirect_to action: :index
  end

  private

  def dream_params
    params.require(:dream).permit(:title, :description, :came_true)
  end

  def find_dream
    Dream.find(params[:id])
  end
end
