module ApplicationHelper
  def slug_path(post)
    if post.published?
      post.slug_path
    else
      unpublished_post_path(post)
    end
  end
end
