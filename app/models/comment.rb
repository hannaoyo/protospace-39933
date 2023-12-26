class Comment < ApplicationRecord
  belongs_to :prototype  # prototypesテーブルとのアソシエーション
  belongs_to :user  # usersテーブルとのアソシエーション
  has_one_attached :image
  
  validates :text, presence: true
end
