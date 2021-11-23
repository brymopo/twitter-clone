class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :full_name, presence: true
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  has_many :tweets, dependent: :destroy

  has_many :user_followers, class_name: "Follow", foreign_key: "followed_id"
  has_many :user_following, class_name: "Follow", foreign_key: "follower_id"

  has_many :followers, through: :user_followers, source: :follower
  has_many :following, through: :user_following, source: :followed
end
