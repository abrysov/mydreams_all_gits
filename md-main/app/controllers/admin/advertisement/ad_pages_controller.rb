module Admin
  module Advertisement
    class AdPagesController < Advertisement::ApplicationController
      def index
        @ad_pages = AdPage.order(:id).page params[:page]
      end

      def new
        @ad_page = AdPage.new
      end

      def edit
        @ad_page = find_ad_page
      end

      def show
        @ad_pages = find_ad_page
      end

      def create
        @ad_page = AdPage.new(ad_page_params)
        if @ad_page.save
          redirect_to admin_advertisement_ad_pages_path
        else
          render :edit
        end
      end

      def update
        @ad_page = find_ad_page
        if @ad_page.update_attributes(ad_page_params)
          redirect_to admin_advertisement_ad_pages_path
        else
          render :edit
        end
      end

      def destroy
        AdPage.where(id: params[:id]).destroy_all
        redirect_to admin_advertisement_ad_pages_path
      end

      private

      def ad_page_params
        params.require(:ad_page).permit(:route, banner_ids: [])
      end

      def find_ad_page
        AdPage.find(params[:id])
      end
    end
  end
end
