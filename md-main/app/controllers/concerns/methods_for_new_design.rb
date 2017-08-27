module MethodsForNewDesign
  extend ActiveSupport::Concern

  protected

  def set_new_views_for_admin
    prepend_view_path 'app/new_views' if for_new_design?

    if admin?
      gon.token = JWT.encode(
        { 'user_id' => current_dreamer.id },
        'super-secret-key',
        'HS256'
      )

      gon.messenger_ws_url = "ws://#{Dreams.config.messenger.host}/bullet?token=#{gon.token}"
    end
  end

  def for_new_design?
    admin? || params[:new_design].present?
  end

  def admin?
    current_dreamer&.role&.admin?
  end
end
