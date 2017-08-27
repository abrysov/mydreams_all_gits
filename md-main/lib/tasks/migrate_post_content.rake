namespace :posts do
  desc 'copy Post title and body to content'
  task copy_to_content: :environment do
    sql = "UPDATE posts SET content = CONCAT(title, '\r\n\r\n', body) WHERE content is null"
    Post.connection.execute(sql)
  end
end
