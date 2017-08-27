class ErrorsController < ApplicationController
  before_action :set_new_views_for_admin

  def not_found
    template, layout = if for_new_design?
                         %w(404_new_design application_light)
                       else
                         %w(404 application)
                       end
    render template, layout: layout, status: 404
  end

  def server_error
    template, layout = if for_new_design?
                         %w(500_new_design application_light)
                       else
                         %w(500 application)
                       end
    render template, layout: layout, status: 500
  end
end
