class User < ActiveRecord::Base
	has_secure_password
	has_many :subscriptions

	validates :name, presence: true, length: { maximum: 50 }, uniqueness: true
	validates :password, presence: true, length: { minimum: 10 }
end
