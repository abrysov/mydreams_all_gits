class DeletedDreamer
  attr_accessor :id

  def initialize(options = {})
    @id = options[:id].to_i
  end

  def first_name
    I18n.t('activerecord.attributes.deleted_dreamer.first_name')
  end

  def last_name
    I18n.t('activerecord.attributes.deleted_dreamer.last_name')
  end

  def is_vip?
    false
  end

  def online?
    false
  end

  def avatar
    nil
  end

  def gender
    'male'
  end

  def age
    0
  end

  def dream_city
    nil
  end

  def send_to(*args)
    Message.none
  end
end
