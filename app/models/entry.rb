# DM機能のため追加
class Entry < ApplicationRecord
  belongs_to :user
  belongs_to :room
end
