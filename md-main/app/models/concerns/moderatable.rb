module Moderatable
  extend ActiveSupport::Concern
  include Abusable

  included do
    scope :not_reviewed, -> { where(review_date: nil) }
    scope :not_deleted, -> { where(deleted_at: nil) }
    scope :active, -> { where(deleted_at: nil, blocked_at: nil) }
    after_update :reset_review_date
  end

  def approve
    update_columns(review_date: DateTime.now)
  end

  def remove_approve
    update_columns(review_date: nil)
  end

  def approved?
    !!review_date
  end

  def block!
    update_columns(blocked_at: DateTime.now)
  end

  def blocked?
    !!blocked_at
  end

  def deleted?
    !!deleted_at
  end

  def unblock!
    update_columns(blocked_at: nil)
  end

  def approve_ios
    update_columns(ios_safe: true)
  end

  def remove_ios_safe
    update_columns(ios_safe: false)
  end

  def ios_safe?
    !!ios_safe
  end

  def mark_deleted
    update_columns(deleted_at: Time.zone.now)
  end

  def mark_undeleted
    update_columns(deleted_at: nil)
  end

  def reset_review_date
    atrs = %w(body avatar first_name status last_name title photo description body)
    atrs.each do |attribute|
      if has_attribute?(attribute) && send("#{attribute}_changed?".to_sym)
        update_columns(review_date: nil, ios_safe: false)
        break
      end
    end
  end
end
