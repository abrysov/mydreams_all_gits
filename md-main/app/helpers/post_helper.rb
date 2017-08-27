module PostHelper
  def clear_format(post)
    sanitize(simple_format(post.to_s), tags: %w(br p))
  end
end
