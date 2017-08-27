class EventsController < ApplicationController
  before_filter :authenticate_dreamer!

  def index
  end
end
