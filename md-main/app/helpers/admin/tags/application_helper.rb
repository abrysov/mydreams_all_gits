module Admin
  module Tags
    module ApplicationHelper
      def hierarchy_tree(tag)
        (tag.ancestors.reverse + [tag] + tag.descendants)
      end

      def active_flag(flag)
        text = flag ? 'on' : 'off'
        class_name = flag ? 'alert-success' : 'alert-danger'
        content_tag(:span, text, class: class_name)
      end

      def hierarchy_link_tree(tag)
        hierarchy_tree(tag).map do |one_tag|
          link_to one_tag.name, one_tag.link
        end
      end
    end
  end
end
