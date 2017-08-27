class CroppersController < ApplicationController
  before_filter :authenticate_admin_user!

  def new
    load_top_dream
    render 'croppers/new', layout: 'admin_empty'
  end

  def create
    load_top_dream
    if @top_dream
      @top_dream.photo = File.open(image_from_db.path)
      @top_dream.title = File.basename(@top_dream.photo.path, '.*') if @top_dream.title.blank?
      @top_dream.save
    end
    redirect_to admin_top_dreams_path
  end
  private

  def image_from_db
    image = MiniMagick::Image.open(@top_dream.photo.path)
    image.crop crop_params
    image.write @top_dream.photo.path
    image
  end

  def crop_params
    "#{params[:picture_w]}x#{params[:picture_h]}+#{params[:picture_x]}+#{params[:picture_y]}"
  end

  def load_top_dream
    @top_dream = TopDream.unscoped.where(id: params[:id]).first
  end
end
