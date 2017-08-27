module Admin
  module ApplicationHelper
    def admin_menu
      @admin_menu ||= I18n.t('admin').keys.map do |section|
        { name: translate_section(section),
          path: send("admin_#{section}_root_path".to_sym) }
      end
    end

    def admin_section_menu(section)
      @section_menu ||= I18n.t('menu', scope: [:admin, section]).map do |model_name, title|
        { name: title, path: menu_path(section, model_name) }
      end
    end

    def menu_path(section, object)
      send("admin_#{section}_#{object}_path".to_sym)
    end

    def current_section
      controller_path.split('/')[1]
    end

    def translate_section(section)
      I18n.t(:name, scope: [:admin, section])
    end

    def show_link(id, text = nil)
      link_to text || id, controller: controller_name, action: :show, id: id
    end
  end
end
