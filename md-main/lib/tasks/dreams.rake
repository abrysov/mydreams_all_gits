namespace :dreams do
  desc 'Migrate top dreams'
  task top_dreams: :environment do
    MigrateDreams.call
  end

  desc 'fill fulfilled_at for all came_true Dreams'
  task fill_fulfilled_at: :environment do
    sql = 'UPDATE dreams SET fulfilled_at = updated_at WHERE came_true = TRUE'
    Dream.connection.execute(sql)
  end
end
