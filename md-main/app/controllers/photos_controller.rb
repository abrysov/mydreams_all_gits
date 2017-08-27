class PhotosController < ApplicationController
  before_action :authenticate_dreamer!, except: [:index, :show]
  before_action :load_dreamer, only: [:index, :show]

  def index
    @photo = @dreamer ? @dreamer.photos.build : Photo.build

    if params[:photo_count]
      @photos = @dreamer.photos.not_deleted.order(id: :desc).first(params[:photo_count].to_i)
    else
      @photos = @dreamer.photos.not_deleted.order(id: :desc)
    end

    build_photo

    respond_to do |format|
      format.json do
        @gallery = @photos.map do |photo|
          { img: photo.file.url(:large), thumb: photo.file.url(:small), caption: photo.caption, del_link: dreamer_photo_path(@dreamer, photo) }
        end

        render json: @gallery, root: false
      end

      format.html do
        render 'photos/index', layout: (request.xhr? ? false : 'flybook'), locals: { dreamer: @dreamer, photos: @photos }
      end
    end
  end

  def new
    build_photo
  end

  def edit
    load_photo
  end

  def create
    build_photo
    save_photo
    apply_redirect
  end

  def update
    load_photo
    build_photo

    if save_photo
      render json: {caption: @photo.caption}
    else
      head 500
    end
  end

  def destroy
    load_photo
    if destroy_photo
      render json: {delete: true}
    end
  end

  def upload
    @photo = Photo.new(file: params[:file], dreamer: current_dreamer)

    if @photo.save
      render partial: 'photos/photo', layout: false, locals: {dreamer: current_dreamer, photo: @photo}
    else
      head 500
    end
  end

  def show
    load_photo
    @dreamers_liked = @photo.liked_dreamers
  end

  private

  def photo_scope
    current_dreamer.try(:photos) || Photo.all
  end

  def load_photo
    @photo ||= photo_scope.find(params[:id])
  end

  def build_photo
    @photo ||= photo_scope.build
    @photo.attributes = photo_params
  end

  def save_photo
    @photo.save
  end

  def destroy_photo
    @photo.destroy
  end

  def apply_redirect(notice = '')
    redirect_to :back, notice: notice
  end

  def photo_params
    return {} if params[:photo].blank?
    params.require(:photo).permit(:file, :caption)
  end
end
