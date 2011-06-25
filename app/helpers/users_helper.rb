module UsersHelper
  def commentable_url(a)
    commentable = controller.controller_name.singularize
    commentable_instance = controller.instance_variable_get("@#{commentable}")
    user_comments_path(a, :commentable_type => commentable, :commentable_id => commentable_instance.id)
  end
end
