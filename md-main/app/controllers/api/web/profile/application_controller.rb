class Api::Web::Profile::ApplicationController < Api::Web::ApplicationController
  before_action :authorize_dreamer!

  def authorize_dreamer!
    render_forbidden unless dreamer_signed_in?
  end
end

