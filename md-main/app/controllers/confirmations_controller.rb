class ConfirmationsController < Devise::ConfirmationsController
  include MethodsForNewDesign
  layout :layout_name
  skip_before_action :check_if_active
  before_action :redirect_unless_signed_in, only: :new

  def new
    if current_dreamer
      redirect_to account_dreamer_dreams_path(current_dreamer) if current_dreamer.confirmed?
    else
      redirect_to new_dreamer_session_path
    end
  end

  def create
    email = params[:dreamer][:email]
    @error = email_error(email)
    render(:new) && return if @error

    if !current_dreamer || current_dreamer.try(:email) == email
      super and return
    elsif current_dreamer.email != email && Dreamer.where(email: email).empty?
      current_dreamer.update(unconfirmed_email: email) if current_dreamer
      super
    else
      render :new
    end
  end

  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    yield resource if block_given?

    if resource.errors.empty?
      set_flash_message(:notice, :confirmed) if is_flashing_format?
      redirect_to after_resending_confirmation_instructions_path_for(resource_name)
    else
      @error = t('.wrong_token', scope: :devise)
      render :new
    end
  end

  private

  def email_error(email)
    error = t('.wrong_email', scope: :devise) if email.blank?

    if known_email = Email.find_by(email: email)
      error = if known_email.soft_bounce || known_email.hard_bounce
                t('.wrong_email', scope: :devise)
              elsif known_email.spam
                t('.spam', scope: :devise)
              elsif known_email.unsub
                t('.unsub', scope: :devise)
              end
    end
    error
  end

  def redirect_unless_signed_in
    redirect_to new_dreamer_session_path unless current_dreamer
  end

  protected

  def layout_name
    for_new_design? ? 'application_light' : 'empty_layout'
  end

  # The path used after resending confirmation instructions.
  def after_resending_confirmation_instructions_path_for(resource_name)
    current_dreamer ? account_dreamer_path(current_dreamer) : new_session_path(resource_name)
  end

  # The path used after confirmation.
  def after_confirmation_path_for(resource_name, resource)
    current_dreamer ? account_dreamer_path(current_dreamer) : root_path
  end
end
