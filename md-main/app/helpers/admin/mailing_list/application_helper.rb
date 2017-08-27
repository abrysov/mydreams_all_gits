module Admin
  module MailingList
    module ApplicationHelper
      def menu_active_class(link_path)
        current_page?(link_path) ? 'active' : ''
      end
    end
  end
end
