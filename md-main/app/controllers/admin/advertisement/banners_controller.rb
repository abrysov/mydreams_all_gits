module Admin
  module Advertisement
    class BannersController < Advertisement::ApplicationController
      def index
        @banners = Banner.order(:id).page params[:page]
      end

      def new
        @banner = Banner.new
      end

      def edit
        @banner = find_banner
      end

      def show
        @dreamers = find_banner
      end

      def create
        @banner = Banner.new(banner_params)
        if @banner.save
          redirect_to admin_advertisement_banners_path
        else
          render :edit
        end
      end

      def update
        @banner = find_banner
        if @banner.update_attributes(banner_params)
          redirect_to admin_advertisement_banners_path
        else
          render :edit
        end
      end

      def destroy
        Banner.where(id: params[:id]).destroy_all
        redirect_to admin_advertisement_banners_path
      end

      private

      def banner_params
        new_params = params.require(:banner).
                     permit(:image, :link, :date_start, :date_end, :name, ad_page_ids: [])
        new_params['date_start'] = parse_moscow_time(new_params['date_start'])
        new_params['date_end']   = parse_moscow_time(new_params['date_end'])
        new_params
      end

      def parse_moscow_time(time)
        ActiveSupport::TimeZone['Moscow'].parse(time)
      end

      def find_banner
        Banner.find(params[:id])
      end
    end
  end
end
