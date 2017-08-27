class Admin::Tags::AdBannersController < Admin::Tags::ApplicationController
  def index
    @ad_banners = AdBanner.includes(:tags).order(:id).page params[:page]
  end

  def new
    @ad_banner = AdBanner.new
  end

  def edit
    @ad_banner = find_ad_banner
  end

  def create
    @ad_banner = AdBanner.new(ad_banners_params_with_tag_ids)
    if @ad_banner.save
      render :show
    else
      render :edit
    end
  end

  def show
    @ad_banner = find_ad_banner
  end

  def update
    @ad_banner = find_ad_banner
    if @ad_banner.update_attributes(ad_banners_params_with_tag_ids)
      render :show
    else
      render :edit
    end
  end

  def destroy
    AdBanner.where(id: params[:id]).destroy_all
    redirect_to admin_tags_ad_banners_path
  end

  private

  def find_ad_banner
    AdBanner.find(params[:id])
  end

  def ad_banners_params
    params.require(:ad_banner).permit(:url, :image, :active, tags: [])
  end

  def ad_banners_params_with_tag_ids
    new_params = ad_banners_params
    new_params.delete(:tags)
    new_params.merge(tag_ids: tag_ids_from_names)
  end

  def tag_ids_from_names
    Tag.where(name: ad_banners_params[:tags]).map(&:id).flatten.uniq
  end
end
