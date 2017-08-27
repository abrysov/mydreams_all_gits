require 'sprite_factory'
require 'carrierwave'

namespace :assets do
  desc 'recreate sprite images and css'
  task :resprite => :environment do 
    SpriteFactory.cssurl = "image-url('$IMAGE')"    # use a sass-rails helper method to be evaluated by the rails asset pipeline
    SpriteFactory.run!('app/assets/images/sprite/', :output_style => 'app/assets/stylesheets/sprite.css.scss', :selector => '.i_')
  end

  desc 'recreate avatar thumbs'
  task :recreate_versions => :environment do
  	@dreamer_with_avatar = Dreamer.where("avatar IS NOT NULL")
  	
  	@dreamer_with_avatar.each do |dreamer|
			dreamer.avatar.recreate_versions!
		end
  end
end