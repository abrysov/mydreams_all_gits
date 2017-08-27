module DreamHelper
  def dream_launches(dream)
    number_to_human(
      dream.launches_count,
      format: '%n%u',
      strip_insignificant_zeros: true,
      units: { thousand: 'K' }
    )
  end

  def dream_status_for(dream)
    dream_type = dream.summary_certificate_type_name || 'my_dreams'
    dream_title = dream_type.titleize

    content_tag :div, dream_title, 'data-dream-type': dream_type, class: 'dream-status'
  end
end
