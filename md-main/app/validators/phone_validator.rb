class PhoneValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    len = value.gsub(/[^\d]/, '').length
    if len < 9 || len > 14
      record.errors.add(attribute, I18n.t('errors.dreamer.phone.wrong_format'))
    end
  end
end