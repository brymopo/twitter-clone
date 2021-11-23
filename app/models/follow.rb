class Follow < ApplicationRecord
  belongs_to :follower, class_name: "User", foreign_key: "follower_id", counter_cache: :following_count
  belongs_to :followed, class_name: "User", foreign_key: "followed_id", counter_cache: :followers_count
  validates_presence_of :follower_id, :followed_id
  validates :follower_id, uniqueness: { scope: [:followed_id] }, identity: true
end
