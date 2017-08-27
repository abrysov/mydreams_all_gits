# encoding: utf-8
class Account::SuggestedDreamsController < Account::ApplicationController
  def accept
    load_suggested_dream

    if current_dreamer?(@suggested_dream.receiver)
      create_new_dream
      @suggested_dream.delete
      render partial: 'account/dreams/dream', locals: {dream: @dream}
    else
      render text: 'Only receiver can accept suggested dream'
    end
  end

  def reject
    load_suggested_dream
    @suggested_dream.delete
    redirect_to :back
  end

  private

  def load_suggested_dream
    @suggested_dream = SuggestedDream.find(params[:id])
  end

  def create_new_dream
    suggested = @suggested_dream.dream
    @dream = Dream.new suggested.attributes.select{|k,v| %w{title description photo restriction_level}.include?(k) }
    @dream.photo = suggested.photo
    @dream.video = suggested.video
    @dream.dreamer = current_dreamer
    @dream.suggested_from_id = suggested.id

    if @dream.save
      photo_root_img_folder = Rails.root.join('public', 'uploads', 'dream', 'photo')
      video_root_img_folder = Rails.root.join('public', 'uploads', 'dream', 'video')
      begin
        FileUtils.copy_entry(photo_root_img_folder.join(suggested.id.to_s), photo_root_img_folder.join(@dream.id.to_s))
        FileUtils.copy_entry(video_root_img_folder.join(suggested.id.to_s), video_root_img_folder.join(@dream.id.to_s))
      rescue
      end
    end
  end
end
