class MigrateActivities
  def self.call
    Activity.where(key: 'comment_create').find_each do |activity|
      key = "#{activity.trackable.commentable_type.downcase}_comment"
      activity.update_attributes(key: key)
    end
  end
end
