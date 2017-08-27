# encoding: utf-8
class Account::SuggestedPostsController < Account::ApplicationController
  def accept
    load_suggested_post

    if current_dreamer?(@suggested_post.receiver)
      create_new_post
      @suggested_post.delete
      render partial: 'account/posts/post', locals: {post: @post}
    else
      render text: 'Only receiver can accept suggested post'
    end
  end

  def reject
    load_suggested_post
    @suggested_post.delete
    redirect_to :back
  end

  private

  def load_suggested_post
    @suggested_post = SuggestedPost.find(params[:id])
  end

  def create_new_post
    suggested = @suggested_post.post
    @post = Post.new suggested.attributes.select{|k,v| %w{title body photo restriction_level}.include?(k) }
    @post.photo = suggested.photo
    @post.dreamer = current_dreamer
    @post.suggested_from_id = suggested.id

    if @post.save
      photo_root_img_folder = Rails.root.join('public', 'uploads', 'post', 'photo')
      begin
        FileUtils.copy_entry(photo_root_img_folder.join(suggested.id.to_s), photo_root_img_folder.join(@post.id.to_s))
      rescue
      end
    end
  end
end
