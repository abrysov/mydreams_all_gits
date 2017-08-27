class Post < ActiveRecord::Base
  include Commentable
  include Complainable
  include DreamerDeletable
  include Likeable
  include Logable
  include Moderatable
  include Restrictable

  before_validation :fill_content, if: -> { title.present? && body.present? }
  after_create :fill_photos, if: -> { title.present? && body.present? }

  belongs_to :dreamer
  has_many :photos, dependent: :destroy, class_name: 'PostPhoto'
  has_many :suggested_posts, dependent: :destroy
  belongs_to :parent, class_name: 'Post'

  include PgSearch
  multisearchable against: :content
  pg_search_scope :fulltext_search, against: :content,
                                    using: { tsearch: { prefix: true } }

  validates :dreamer, :content, presence: true
  validates :restriction_level, inclusion: { in: (0..2) }

  mount_uploader :photo,            PostPhotoUploader
  mount_base64_uploader :photo,     PostPhotoUploader

  scope :not_deleted, -> { where(deleted_at: nil) }

  class << self
    def search(q)
      q.present? ? fulltext_search(q) : where(false)
    end
  end

  def to_s
    title
  end

  def description
    body
  end

  def fill_content
    self.content = title + "\r\n\r\n" + body
  end

  def fill_photos
    photos.create(photo: photo)
  end
end
