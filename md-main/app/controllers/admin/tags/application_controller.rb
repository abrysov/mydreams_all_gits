class Admin::Tags::ApplicationController < ActionController::Base
  layout 'admin/tags'
  before_action :authenticate_dreamer!
  before_action :authenticate_admin

  def search_tags
    if params[:q] && params[:q].present?
      render json: Tag.limit(20).ransack(name_cont_any: params[:q]).result
    else
      render json: Tag.limit(20).roots
    end
  end

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
