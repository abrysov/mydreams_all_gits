class Admin::Management::ApplicationController < ApplicationController
  layout 'admin/management'
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  before_action :authenticate_dreamer!
  before_action :check_access
  before_action :set_application

  def authenticate_dreamer!
    redirect_to root_path unless dreamer_signed_in?
  end

  def check_access
    unless %w(admin).include? current_dreamer.role
      redirect_to root_path
    end
  end

  private

  def page
    [params[:page].to_i, 1].max
  end

  def per_page
    per = params[:per].to_i
    per <= 0 ? 10 : per
  end

  def render_not_found
    flash[:error] = t('management.errors.not_found')
    redirect_to admin_management_products_path
  end

  def set_properties
    %w(locale gateway_id gateway_rate
       certificate_name certificate_launches
       vip_duration previous_id new_id)
  end

  def set_application
    @product_properties ||= set_properties
  end

  def log_action!(action: action_name, logable: request_entity_object)
    LogAction::Management.call(action, logable, current_dreamer)
  end
end
