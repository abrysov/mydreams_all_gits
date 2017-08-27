namespace :friendships do
  desc 'Migrates friendships data to new scheme'
  task migrate_data: :environment do
    MigrateFriendships.call
  end
end
