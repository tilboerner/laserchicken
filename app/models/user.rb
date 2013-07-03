class User < ActiveRecord::Base
  has_secure_password

  has_many :subscriptions, dependent: :destroy
  has_many :user_states, dependent: :destroy

  validates :name, presence: true, length: { maximum: 50 }, uniqueness: true
  validates :password, length: { minimum: 10 }
end
