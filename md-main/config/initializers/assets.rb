# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
# Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
# Rails.application.config.assets.precompile += %w( jquery.Jcrop.css jquery.Jcrop.js active_admin/* *.eot *.woff *.ttf *.css *.js active_admin.css active_admin.js Moxie.swf Moxie.xap jquery.plupload.queue/* jquery.ui.plupload/*)

Rails.application.config.assets.precompile += %w( cropper/* Moxie.swf Moxie.xap *.png *.gif )
Rails.application.config.assets.precompile += %w( moderate/output.css )
Rails.application.config.assets.precompile += %w( moderate/bootstrap.min.js )
