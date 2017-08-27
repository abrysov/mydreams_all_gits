module SerializersUrlHelper
  def serialized_url(url)
    if ['production', 'staging'].include?(Rails.env)
      if url.present? && url.starts_with?('//')
        "#{ Rails.env.production? ? 'https' : 'http' }:#{ url }"
      else
        url
      end
    else
      url
    end
  end

  def avatar_or_default(object, version = :large)
    if object.avatar.present?
      object.avatar.url(version)
    else
      default_avatar(version, object.gender)
    end
  rescue
    default_avatar(version, true)
  end

  private

  def default_avatar(version, gender)
    path = "defaults/avatars/#{gender}_#{version}.png"
    ActionController::Base.helpers.asset_url(path)
  end
end
