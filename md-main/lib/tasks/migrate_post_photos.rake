namespace :attachments do
  desc 'Migrate Post photos to attachments'
  task migrate_post_photos: :environment do
    MigratePostPhotos.call
  end
end
