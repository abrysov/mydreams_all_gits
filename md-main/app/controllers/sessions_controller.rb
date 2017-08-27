class SessionsController < Devise::SessionsController
  include MethodsForNewDesign
  layout :layout_name

  def create
    session.delete(:data_lack)

    # build_resource
    resource = Dreamer.find_for_database_authentication(login: params[:dreamer][:login])
    return invalid_login_attempt unless resource

    if resource.valid_password?(params[:dreamer][:password])
      sign_in(resource_name, resource)

      if request.xhr?
        return render json: {success: true, id: resource.id, login: resource.login, email: resource.email}
      else
        return respond_with resource, location: after_sign_in_path_for(resource)
      end
    end
    invalid_login_attempt
  end

  protected

  def layout_name
    'application_light' if for_new_design?
  end

  def invalid_login_attempt
    warden.custom_failure!
    if request.xhr?
      render json: {errors: [message: t('authentication.errors.invalid_password')]}
    else
      self.resource = Dreamer.new
      @login_error = t('authentication.errors.invalid_password')
      render :new
    end
  end
end
