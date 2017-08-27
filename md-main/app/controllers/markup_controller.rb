class MarkupController < ApplicationController
  before_action do
    prepend_view_path 'app/new_views'
  end

  def show
    render params[:id], layout: layout
  end

  def layout
    page = params[:id]
    if %w(ui engineering_works).include?(page)
      false
    elsif %w(about blocked confirm_email confirm_email2 error registration restore_profile landingpage login 404).include?(page)
      'layouts/application_light'
    elsif %w(password_reset).include?(page)
      'layouts/unauthorized'
    else
      true
    end
  end
end
