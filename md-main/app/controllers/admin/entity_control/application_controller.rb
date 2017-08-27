class Admin::EntityControl::ApplicationController < ActionController::Base
  layout 'admin/entity_control'
  before_action :authenticate_dreamer!
  before_action :authenticate_admin

  protected

  def authenticate_admin
    unless %w(admin).include? current_dreamer.role
      redirect_to new_dreamer_session_path
    end
  end

  def default_url_options(options = {})
    options.merge! locale: I18n.locale
  end
end
