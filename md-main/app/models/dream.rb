class Dream < ActiveRecord::Base
  include Complainable
  include DreamerDeletable
  include Likeable
  include Logable
  include Moderatable
  include Commentable
  include Restrictable

  include PgSearch
  multisearchable against: [:title, :description, :created_at, :updated_at, :id],
                  unless: :top_dream?
  pg_search_scope :fulltext_search,
                  against: [:title, :description],
                  using: { tsearch: { prefix: true } }

  belongs_to :taken_from, class_name: 'Dream'
  belongs_to :dreamer
  belongs_to :summary_certificate_type, class_name: CertificateType

  has_many :suggested_dreams, dependent: :destroy
  has_many :attachments, as: :attachmentable, dependent: :destroy
  has_many :certificates, as: :certifiable
  has_many :paid_certificates, -> { where(paid: true) }, as: :certifiable, class_name: 'Certificate'
  has_many :dream_hidden_tags, dependent: :destroy
  has_many :hidden_tags, class_name: Tag,
                         through: :dream_hidden_tags,
                         source: :tag, dependent: :destroy
  has_many :purchases

  delegate :name, to: :summary_certificate_type, allow_nil: true, prefix: true

  attr_accessor :certificate_id # TODO: remove it if you brave

  serialize :photo_crop

  validates :title, presence: true
  validates :dreamer, presence: true, unless: :top_dream?
  validates :restriction_level, inclusion: { in: (0..2) }
  validates :description, presence: true

  before_create :set_position

  mount_uploader :photo, DreamPhotoUploader
  mount_base64_uploader :photo, DreamPhotoUploader
  mount_uploader :video, VideoUploader

  scope :by_position, -> { order(:position) }
  scope :came_true, -> (value = true) { where(came_true: value) }
  scope :not_came_true, -> { where('came_true != true OR came_true IS NULL') }
  scope :not_deleted, -> { where(deleted_at: nil) }
  scope :ordinary_dreams, -> { where(type: nil) }

  def to_s
    title
  end

  def top_dream?
    false
  end

  def certificate
    raise
    current_certificate
  end

  def calculate_launches_count!
    self[:launches_count] = certificates_sum
    save!
  end

  def update_summary_certificate_type!
    self.summary_certificate_type = CertificateType.by_value.detect do |ct|
      ct.value <= launches_count
    end
    save!
  end

  def cropping?
    return false unless photo_crop.present?
    photo_crop[:x] && photo_crop[:y] && photo_crop[:height] && photo_crop[:width]
  end

  def crop_meta
    photo_crop
  end

  def fulfill_dream!
    self.came_true = true
    self.fulfilled_at = Time.zone.now
    save!
  end

  private

  # TODO: intermediate version - fix it
  def certificates_sum
    @certificate_sum ||= paid_certificates.includes(:certificate_type).inject(0) do |sum, cert|
      sum + cert.certificate_type.value
    end
  end

  def set_position
    self.position = (Dream.where(dreamer_id: dreamer_id).by_position.last.try(:position) || 0) + 1
  end

  class << self
    def sort(dreams, current_dreamer)
      dreams.each_with_index do |id, idx|
        dream = Dream.find(id)
        if current_dreamer == dream.dreamer
          dream.update(position: idx)
        end
      end
    end
  end
end
