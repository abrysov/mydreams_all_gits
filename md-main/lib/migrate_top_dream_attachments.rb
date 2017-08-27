module MigrateTopDreamAttachments
  class << self
    def call
      copy_model_image TopDream, :photo
      Rails.logger.info('work done')
    end

    def copy_model_image(klass, attachment)
      Rails.logger.info "starting copy of #{top_dream_files.size}"

      top_dream_files.each do |path|
        begin
          model_id = path.scan(/\d+\b/).first
          model = klass.find(model_id)
          uploader_path = model.send(attachment).store_dir
          path_to = path.sub(/.*\d+\b/, uploader_path)

          Rails.logger.info "coping from #{path} to #{path_to}"
          copy_aws_object(path, path_to)

          update_model_attachment(model, attachment, path)
        rescue => e
          Rails.logger.info "error with TopDream id: #{model.id}"
          Rails.logger.info e.message
        end
      end
    end

    def content_type(path)
      MIME::Types.type_for(path).first.content_type
    end

    def update_model_attachment(model, attachment, path)
      return unless path =~ /admin_/
      filename = path.sub(/.*admin_/, '')
      model.update_column(attachment, filename)
    end

    def aws_connection
      Fog::Storage.new(
        provider: 'AWS',
        aws_access_key_id: Rails.application.secrets.aws_access_key_id,
        aws_secret_access_key: Rails.application.secrets.aws_secret_access_key
      )
    end

    def copy_aws_object(path_from, path_to)
      options = {
        'x-amz-metadata-directive' => 'REPLACE',
        'x-amz-acl'     => 'public-read',
        'Cache-Control' => "max-age=#{1.year.to_i}, must re-validate",
        'Content-Type'  => content_type(path_to),
        'Expires'       => 1.year.from_now.httpdate
      }
      aws_connection.copy_object(bucket, path_from, bucket, path_to, options)
    end

    def bucket
      Rails.application.secrets.attachment_directory
    end

    def top_dream_files
      dir = aws_connection.directories.get(bucket, prefix: 'uploads/top_dream')
      dir.files.map(&:key)
    end
  end
end
