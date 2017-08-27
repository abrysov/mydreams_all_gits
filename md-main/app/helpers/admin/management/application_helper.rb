module Admin
  module Management
    module ApplicationHelper
      def destination_link(object, title = nil)
        case object.class.name
        when 'Dreamer'
          link_to account_dreamer_dreams_path(I18n.locale, object) do
            title || dreamer_fullname(object)
          end
        when 'Dream'
          link_to account_dream_path(I18n.locale, object) do
            title || object.title
          end
        else
          # TODO: else? object.title?
          title
        end
      end

      def external?(transaction)
        transaction.reason.class.name == 'ExternalTransaction'
      end

      def purchase?(transaction)
        transaction.reason.class.name == 'PurchaseTransaction'
      end
    end
  end
end
