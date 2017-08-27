namespace :accounts do
  task migrate_users: :environment do
    DreamMoney::MigrateUsers.call
  end
end
