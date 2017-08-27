module MigratePostPhotos
  class << self
    def call
      copy_model_image Post, :photo
      Rails.logger.info('work done')
    end

    def copy_model_image(klass, attachment)
      models = klass.where.not(attachment => nil)
      Rails.logger.info "starting copy of #{models.count} #{klass.name}'s"
      models.find_each do |model|
        Rails.logger.info "copy Post.photo to PostPhotos, id: #{model.id}"
        name_with_timestamp = model.read_attribute(attachment)
        begin
          versions(model, attachment).each do |version, path|
            copy_object(path, new_path(model, version, name_with_timestamp))
          end
          create_photo_attachment(model, name_with_timestamp)
        rescue => e
          Rails.logger.info "error with #{model.class.name} id: #{model.id}"
          Rails.logger.info e.message
        end
      end
    end

    def content_type(path)
      MIME::Types.type_for(path).first.content_type
    end

    def new_path(model, version, name_with_timestamp)
      uploader = PostPhoto.uploaders[:photo].new(model, :photo)
      version = (version.to_s == '' ? '' : version.to_s + '_')
      uploader.store_dir + '/' + version + name_with_timestamp
    end

    def create_photo_attachment(model, name_with_timestamp)
      post_photo = model.photos.create
      post_photo.update_columns(photo: name_with_timestamp)
    end

    def copy_object(path_from, path_to)
      options = {
        'x-amz-metadata-directive' => 'REPLACE',
        'x-amz-acl'     => 'public-read',
        'Cache-Control' => "max-age=#{1.year.to_i}, must re-validate",
        'Content-Type'  => content_type(path_to),
        'Expires'       => 1.year.from_now.httpdate
      }
      aws_connection.copy_object(bucket, path_from, bucket, path_to, options)
    end

    def versions(model, attachment)
      hsh = { '' => model.send(attachment).path }
      model.send(attachment).versions.inject(hsh) do |acc, version|
        acc[version.first] = version.last.file.path
        acc
      end
    end

    def aws_connection
      Fog::Storage.new(
        provider: 'AWS',
        aws_access_key_id: Rails.application.secrets.aws_access_key_id,
        aws_secret_access_key: Rails.application.secrets.aws_secret_access_key
      )
    end

    def bucket
      Rails.application.secrets.attachment_directory
    end
  end
end
