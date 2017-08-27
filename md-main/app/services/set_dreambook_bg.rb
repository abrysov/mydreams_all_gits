class SetDreambookBg
  attr_reader :dreamer, :file, :crop_meta

  def initialize(dreamer:, file:, crop_meta:)
    @dreamer = dreamer
    @file = file
    @crop_meta = crop_meta
  end

  def call
    dreamer.crop_meta = merge_dremer_dreambook
    dreamer.dreambook_bg = file

    if dreamer.save
      Result::Success.new
    else
      Result::Error.new
    end
  end

  private

  def merge_dremer_dreambook
    if dreamer.crop_meta.nil?
      { dreambook_bg: crop_meta }
    else
      dreamer.crop_meta.merge(dreambook_bg: crop_meta)
    end
  end
end
