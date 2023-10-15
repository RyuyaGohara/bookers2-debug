module NotificationsHelper
  
  def transition_path(notification)
    case notification.action_type.to_sym
    when :commented_to_own_post
      book_path(notification.subject.book, anchor: "comment-#{notification.subject.id}")
    when :liked_to_own_post
      book_path(notification.subject.book)
    when :followed_me
      user_path(notification.subject.follower)
    end
  end
  
end
