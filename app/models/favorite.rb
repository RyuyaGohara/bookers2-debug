class Favorite < ApplicationRecord

  belongs_to :user
  belongs_to :book

  has_one :notification, as: :subject, dependent: :destroy

  after_create_commit :create_notifications

  private

  def create_notifications
    # 自分の投稿にいいねした場合は通知を作成しない
    return if self.user == self.book.user
    Notification.create(subject: self, user: self.book.user, action_type: :liked_to_own_post)
  end

end
