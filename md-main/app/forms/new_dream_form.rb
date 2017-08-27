class NewDreamForm
  include ActiveModel::Model
  include Virtus.model
  attr_reader :dream

  attribute :title
  attribute :description
  attribute :certificate_id
  attribute :dreamer
  attribute :photo
  attribute :restriction_level, Integer
  attribute :came_true
  attribute :photo_crop

  validates :title, presence: true
  validates :dreamer, presence: true
  validates :photo, presence: true
  validates :restriction_level, inclusion: { in: (0..2) }
  validate :ckeck_dreamer_email_presence

  def initialize(dreamer:, params: {})
    @dreamer = dreamer
    super(params)
  end

  def save
    if valid?
      persist!
      true
    else
      false
    end
  end

  def persisted?
    dream && dream.persisted?
  end

  def new_record?
    !persisted?
  end

  private

  def persist!
    @dream ||= Dream.create(
      title: title,
      description: description,
      certificate_id: certificate_id,
      dreamer: dreamer,
      restriction_level: restriction_level,
      came_true: came_true,
      photo_crop: photo_crop
    )

    @dream.update(photo: photo)
  end

  def ckeck_dreamer_email_presence
    return if dreamer.email

    errors.add(:base, :blank)
  end
end
