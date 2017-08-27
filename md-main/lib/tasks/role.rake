namespace :role do
  desc "update Dreamers with default role"
  task set_default: :environment do
    Dreamer.update_all(role: 'user')
  end

end
