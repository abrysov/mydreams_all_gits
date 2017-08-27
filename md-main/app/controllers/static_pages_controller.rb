class StaticPagesController < ApplicationController
  def about
    render 'about', layout: 'application_light' if for_new_design?
  end

  def agreement
  end
end
