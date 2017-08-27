class Like < ActiveRecord::Base
  belongs_to :likeable, polymorphic: true, counter_cache: true
  belongs_to :dreamer

  validates :dreamer, :likeable, presence: true

  after_create :add_feedback

  def to_s
    self.class.to_s
  end

  private

  def add_feedback
    return if likeable.is_a?(TopDream) || likeable.dreamer.nil?

    Feed::Feedback::Create.call(
      initiator: dreamer,
      dreamer: likeable.dreamer,
      resource: likeable,
      action: "#{likeable_type.downcase}_liked"
    )
  end
end
