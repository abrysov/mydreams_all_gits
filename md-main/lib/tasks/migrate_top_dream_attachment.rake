namespace :attachments do
  desc 'Coping images for TopDreams'
  task migrate_top_dream_attachment: :environment do
    MigrateTopDreamAttachments.call
  end
end
