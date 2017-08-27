class NotificationWorker
  include Sidekiq::Worker

  def perform(activity_id)
    activity = Activity.find(activity_id)

    activity.owner.subscribers.each do |friend|
      Notification.create(
        dreamer: friend,
        initiator: activity.owner,
        resource: activity.trackable,
        action: activity.key
      )
    end
  end
end
