module Admin
  module Advertisement
    class ApplicationController < ActionController::Base
      layout 'admin/advertisement'
      before_action :authenticate_dreamer!
      before_action :authenticate_admin
      skip_before_action :set_new_views_for_admin

      protected

      def authenticate_admin
        unless %w(admin).include? current_dreamer.role
          redirect_to root_path
        end
      end

      def default_url_options(options = {})
        options.merge! locale: I18n.locale
      end
    end
  end
end
