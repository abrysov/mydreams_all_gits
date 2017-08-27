class NewDreamerForm
  include Virtus.model
  include ActiveModel::Model
  attr_reader :dreamer

  attribute :email
  attribute :first_name
  attribute :last_name
  attribute :gender
  attribute :phone
  attribute :password
  attribute :birthday
  attribute :dream_city_id
  attribute :dream_country_id
  attribute :terms_of_service

  validates :email, presence: true, email: true
  validates :phone, phone: true, allow_blank: true
  validates :first_name, presence: true
  validates :gender, inclusion: { in: %w(male female) }, presence: true
  validates :password, presence: true
  validates :terms_of_service, acceptance: true
  validate :check_email_uniqueness

  def save
    if valid?
      persist!
      true
    else
      false
    end
  end

  def persisted?
    dreamer && dreamer.persisted?
  end

  def new_record?
    !persisted?
  end

  private

  def persist!
    @dreamer ||= RegisterDreamer.call(
      email: email,
      first_name: first_name,
      last_name: last_name,
      gender: gender,
      phone: phone,
      password: password,
      birthday: birthday,
      terms_of_service: terms_of_service,
      dream_city_id: dream_city_id,
      dream_country_id: dream_country_id
    )
  end

  def check_email_uniqueness
    return unless Dreamer.where('lower(email) = lower(?)', email).exists?

    errors.add(:email, :not_unique)
  end
end
