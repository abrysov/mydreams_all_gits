module Admin
  module Advertisement
    class AdvertisersController < Advertisement::ApplicationController
      def index
        @advertisers = Advertiser.order(:id).page params[:page]
      end

      def new
        @advertiser = Advertiser.new
      end

      def edit
        @advertiser = find_advertiser
      end

      def show
        @advertiser = find_advertiser
      end

      def create
        @advertiser = Advertiser.new(advertiser_params)
        if @advertiser.save
          redirect_to admin_advertisement_advertisers_path
        else
          render :edit
        end
      end

      def update
        @advertiser = find_advertiser
        if @advertiser.update_attributes(advertiser_params)
          redirect_to admin_advertisement_advertisers_path
        else
          render :edit
        end
      end

      def destroy
        find_advertiser.destroy
        redirect_to admin_advertisement_advertisers_path
      end

      private

      def advertiser_params
        params.require(:advertiser).permit(:name, :description)
      end

      def find_advertiser
        Advertiser.find(params[:id])
      end
    end
  end
end
