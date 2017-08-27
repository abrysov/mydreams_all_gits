module Moderate::ApplicationHelper
  def approved_title(obj)
    t('moderate.shared.actions.approved') + ' ' + short_time(obj.review_date)
  end

  def dreamer_link(dreamer, title = nil)
    link_to title || dreamer_fullname(dreamer), account_dreamer_dreams_path(I18n.locale, dreamer)
  end

  def short_date(date)
    I18n.l date, format: :short
  end

  def short_time(date)
    date.strftime('%H:%M')
  end

  def dreamer_fullname(dreamer)
    [dreamer.first_name, dreamer.last_name].reject(&:blank?).join(' ')
  end

  def dreamer_name_of_object(object)
    dreamer = object.is_a?(Dreamer) ? object : object.dreamer
    dreamer_fullname(dreamer)
  end

  def dreamer_state(dreamer)
    return I18n.t('dreamer.blocked') if dreamer.blocked_at
    return I18n.t('dreamer.deleted') if dreamer.deleted_at
  end

  def dreamer_of_object(object)
    object.is_a?(Dreamer) ? object : object.dreamer
  end

  def entity_params(object)
    { entity_type: object.class.to_s, entity_id: object.id }
  end

  def mass_entity_params(objects)
    { entity_type: objects.first.class.to_s, entity_ids: objects.map(&:id) }
  end
end
