class BookComment < ApplicationRecord

  belongs_to :user
  belongs_to :book
  validates :comment, presence: true

  has_one :notification, as: :subject, dependent: :destroy

  after_create_commit :create_notifications

  private

  def create_notifications
    # 自分の投稿にコメントした場合は通知を作成しない
    return if self.user == self.book.user
    Notification.create(subject: self, user: book.user, action_type: :commented_to_own_post)
  end

end
