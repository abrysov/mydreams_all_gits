namespace :statuses do
  desc "Import statuses from Statuses table to Profile table"
  task move_to_dreamer: :environment do
    target_dreamers = Dreamer.where(status: nil)
    Rails.logger.info "number of records: #{target_dreamers.count}"
    Rails.logger.info 'Start copying statuses...'
    target_dreamers.find_each do |user|
      begin
        if user.current_status && user.status.is_a?(Status)
          user.update status: user.current_status.title
        end
      rescue Exception => e
        Rails.logger.info e.message
        Rails.logger.info e.backtrace.inspect
      end
    end
    Rails.logger.info 'Copying statuses finished'
  end
end
