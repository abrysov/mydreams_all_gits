class PasswordsController < Devise::PasswordsController
  def create
    @dreamer = Dreamer.send_reset_password_instructions(params[:dreamer])
    if successfully_sent?(@dreamer)
      respond_to do |format|
        format.json { head status: 200 }
        format.html do
          redirect_to new_dreamer_session_path, notice: I18n.t('recovery.password_sended')
        end
      end
    else
      respond_to do |format|
        format.json { render json: { errors: @dreamer.errors.full_messages } }
        format.html do
          @errors = @dreamer.errors.full_messages
          render :new
        end
      end
    end
  end

  def update
    self.resource = resource_class.reset_password_by_token(resource_params)
    yield resource if block_given?

    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)
      try_sign_in(resource)
    else
      respond_with resource, reset_password_token: resource_params[:reset_password_token]
    end
  end

  private

  def try_sign_in(resource)
    if Devise.sign_in_after_reset_password
      flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
      set_flash_message(:notice, flash_message) if is_flashing_format?
      sign_in(resource_name, resource)
      respond_with resource, location: after_resetting_password_path_for(resource)
    else
      set_flash_message(:notice, :updated_not_active) if is_flashing_format?
      respond_with resource, location: new_session_path(resource_name)
    end
  end
end
