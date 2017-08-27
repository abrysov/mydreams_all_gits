class Account::ApplicationController < ApplicationController
  before_filter :authenticate_dreamer!
  before_action :render_blocked_dreamer

  rescue_from CanCan::AccessDenied do
    redirect_to root_path
  end

  protected

  def render_blocked_dreamer
    if params[:dreamer_id].present? && !current_dreamer_id?(params[:dreamer_id])
      dreamer = Dreamer.find_by(id: params[:dreamer_id])
      return true unless dreamer

      if dreamer.blocked_at
        render 'account/dreamers/blocked'
        return false
      elsif dreamer.deleted_at
        render 'account/dreamers/deleted'
        return false
      end

    end
  end

end
