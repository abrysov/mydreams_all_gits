class SetDreamerAvatar
  attr_reader :dreamer, :file, :cropped_file, :crop_meta

  def initialize(dreamer:, file:, cropped_file:, crop_meta:)
    @dreamer = dreamer
    @file = file
    @cropped_file = cropped_file
    @crop_meta = crop_meta
  end

  def call
    original_avatar = Dreamer.transaction do
      avatar = dreamer.avatars.create!(photo: file, crop_meta: crop_meta)
      dreamer.current_avatar_id = avatar.id
      dreamer.crop_meta = merge_dreamer_avatar
      dreamer.avatar = cropped_file
      dreamer.save!
      avatar
    end
    original_avatar.persisted? && dreamer.attribute_present?(:avatar)
  end

  private

  def merge_dreamer_avatar
    if dreamer.crop_meta.nil?
      { avatar: crop_meta }
    else
      dreamer.crop_meta.merge(avatar: crop_meta)
    end
  end
end
