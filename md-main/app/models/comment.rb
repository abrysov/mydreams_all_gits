class Comment < ActiveRecord::Base
  include Complainable
  include Likeable
  include Logable
  include Moderatable
  include PgSearch
  multisearchable against: [:body, :created_at, :updated_at, :id]

  belongs_to :commentable, polymorphic: true, counter_cache: true
  belongs_to :dreamer

  has_many :likes, as: :likeable
  has_many :attachments, as: :attachmentable, dependent: :destroy

  has_ancestry

  validates :body, presence: true
  validates :dreamer, :commentable, presence: true

  after_create :add_feedback

  scope :host_viewed, -> { where(host_viewed: true) }
  scope :not_host_viewed, -> { where(host_viewed: false) }

  private

  def add_feedback
    return unless commentable.respond_to?(:dreamer) && commentable.dreamer

    Feed::Feedback::Create.call(
      initiator: dreamer,
      dreamer: commentable.dreamer,
      resource: commentable,
      action: "#{commentable_type.downcase}_commented"
    )
  end
end
