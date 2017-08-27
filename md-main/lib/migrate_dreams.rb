class MigrateDreams
  def self.call
    Dream.unscoped.where(type: 'TopDream').find_each do |dream|
      Rails.logger.info "starting migrate of #{dream.id} #{dream.title}"

      top = TopDream.create!(title: dream.title, description: dream.description,
                             position: dream.position, likes_count: dream.likes_count,
                             comments_count: dream.comments_count)

      # TODO: fix url
      top.remote_photo_url = fix_url dream.photo.url
      top.save! rescue nil
      top.photo.recreate_versions! rescue nil

      Comment.where(commentable_id: dream.id, commentable_type: 'Dream').
        update_all(commentable_id: top.id, commentable_type: 'TopDream')

      Like.where(likeable_id: dream.id, likeable_type: 'Dream').
        update_all(likeable_id: top.id, likeable_type: 'TopDream')
    end

    # TODO: what to do with it 8(
    # Rails.logger.info 'Create Deprecated TopDream'
    # Dream.where(type: 'TopDream').update_all(type: 'Dream')

    Rails.logger.info 'work done'
    puts 'work done'
  end

  def self.fix_url(url)
    domain = Rails.application.secrets.asset_host || '//localhost:3000'
    "http:#{domain}#{url}"
  end
end
