class Favorite < ApplicationRecord

  belongs_to :user
  belongs_to :book
  
  has_one :notification, as: :subject, dependent: :destroy

  after_create_commit :create_notifications

  private
  def create_notifications
    Notification.create(subject: self, user: self.book.user, action_type: :liked_to_own_post)
  end

end
