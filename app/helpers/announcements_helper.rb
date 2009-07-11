module AnnouncementsHelper
  def commentable_url(a)
    commentable = controller.controller_name.singularize
    announcement_comments_path(a, :commentable_type => commentable, :commentable_id => controller.instance_variable_get("@#{commentable}"))
  end
end
