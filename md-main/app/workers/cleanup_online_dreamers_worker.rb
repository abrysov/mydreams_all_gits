class CleanupOnlineDreamersWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily }

  def perform
    Dreamer.where(online: true).where('last_reload_at < ?', 1.day.ago).update_all(online: false)
  end
end
