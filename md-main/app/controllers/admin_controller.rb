class AdminController < ApplicationController

  def settings
    if params[:settings]
      params[:settings].each do |key, value|
        Setting.where(key: key).first_or_create.update_attributes(value: value)
      end
    end
    redirect_to :back
  end
end
