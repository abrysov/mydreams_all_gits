class Activity < ActiveRecord::Base
  belongs_to :trackable, polymorphic: true
  belongs_to :owner, polymorphic: true

  scope :with_trackable, -> { where.not(trackable: nil) }
  scope :dreamer_owner,  -> { where(owner_type: 'Dreamer') }
  scope :by_created_at,  -> { order(created_at: :desc) }
  scope :not_viewed,     -> { where(viewed: false) }

  class << self
    def filter(f = {})
      f ||= {}
      f[:dreamer_id].present? ? dreamer_owner.where(owner_id: f[:dreamer_id].to_i) : dreamer_owner
    end

    def for_queries(queries)
      return none if queries.empty?
      where(queries.join(' OR ')).by_created_at.with_trackable
    end
  end
end
