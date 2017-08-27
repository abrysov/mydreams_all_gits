class Admin::MailingList::ApplicationController < ActionController::Base
  layout 'admin/mailing_list'
  before_action :authenticate_dreamer!
end
