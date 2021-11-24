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

  scope :alphabetical, -> { order(:full_name) }

  def username=(value)
    value = value.nil? ? value : value.downcase
    super(value)
  end

  def to_param
    username.parameterize
  end

  def tweets_feed(include_following: true)
    ids = [id]
    ids.concat(following.pluck(:id)) if include_following
    Tweet.where(user_id: ids).order("created_at DESC").includes(:user)
  end
end
