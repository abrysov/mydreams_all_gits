module Admin
  module Advertisement
    module ApplicationHelper
      def moscow_time(time)
        msc_time = ActiveSupport::TimeZone['Moscow'].parse(time.to_s)
        I18n.l msc_time, format: :long if msc_time
      end
    end
  end
end
