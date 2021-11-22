class Tweet < ApplicationRecord
  belongs_to :user
  validates :message, presence: true, length: { maximum: 280 }
end
