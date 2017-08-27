class Admin::Tags::AdLinksController < Admin::Tags::ApplicationController
  def index
    @ad_links = AdLink.includes(:tags).order(:id).page params[:page]
  end

  def new
    @ad_link = AdLink.new
  end

  def edit
    @ad_link = find_ad_link
  end

  def create
    @ad_link = AdLink.new(ad_link_params_with_tag_ids)
    if @ad_link.save
      render :show
    else
      render :edit
    end
  end

  def show
    @ad_link = find_ad_link
  end

  def update
    @ad_link = find_ad_link
    if @ad_link.update_attributes(ad_link_params_with_tag_ids)
      render :show
    else
      render :edit
    end
  end

  def destroy
    AdLink.where(id: params[:id]).destroy_all
    redirect_to admin_tags_ad_links_path
  end

  private

  def find_ad_link
    AdLink.find(params[:id])
  end

  def ad_link_params
    params.require(:ad_link).permit(:url, :active, tags: [])
  end

  def ad_link_params_with_tag_ids
    new_params = ad_link_params
    new_params.delete(:tags)
    new_params.merge(tag_ids: tag_ids_from_names)
  end

  def tag_ids_from_names
    Tag.where(name: ad_link_params[:tags]).map(&:id).flatten.uniq
  end
end
