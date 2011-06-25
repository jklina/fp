module NotificationsHelper
  def link_to_notifiable(notification)
    case notification.notifiable_type
    when "Post"
      link_to "post", forum_topic_path(notification.notifiable.topic.forum, notification.notifiable.topic)
    when "Comment"
      link_to "comment", notification.notifiable.commentable
    when "Review"
      link_to "review", notification.notifiable.submission
    else
      "unknown"
    end
  end
end
