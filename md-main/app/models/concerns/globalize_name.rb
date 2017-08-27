module GlobalizeName
  extend ActiveSupport::Concern

  def name
    locales = [:ru, :en]
    self.send("name_#{locales.delete(I18n.locale)}").presence || self.send("name_#{locales.first}")
  end
end
