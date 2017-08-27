class Admin::EntityControl::TopDreamsController < Admin::EntityControl::ApplicationController
  def index
    @top_dreams = TopDream.order(:id).
                  page params[:page]
  end

  def new
    @top_dream = TopDream.new
  end

  def edit
    @top_dream = find_top_dream
  end

  def create
    @top_dream = TopDream.new(top_dream_params)
    if @top_dream.save
      render :show
    else
      render :edit
    end
  end

  def show
    @top_dream = find_top_dream
  end

  def update
    @top_dream = find_top_dream
    @top_dream.update(top_dream_params)
    render :show
  end

  def destroy
    TopDream.where(id: params[:id]).destroy_all
    redirect_to action: :index
  end

  private

  def top_dream_params
    params.require(:top_dream).permit(:title, :description, :photo)
  end

  def find_top_dream
    TopDream.find(params[:id])
  end
end
