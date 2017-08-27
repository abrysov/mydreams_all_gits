class Api::V1::BannersController < Api::V1::ApplicationController
  def show
    banner = find_and_choose_banner
    if banner
      inc_banner_cross_count(banner)
      render json: banner,
             serializer: BannerSerializer,
             meta: { status: 'success', code: 200 },
             status: :ok
    else
      render json: { meta: { status: 'fail', code: 404, message: t('api.failure.not_found') } },
             status: :not_found
    end
  end

  private

  def find_and_choose_banner
    ad_page = AdPage.find_by(route: params[:route])
    if ad_page
      banners = ad_page.active_banners
      banners.relevant.first if banners.any?
    end
  end

  def inc_banner_cross_count(banner)
    Banner.where(id: banner.id).update_all('show_count = show_count + 1')
  end
end
