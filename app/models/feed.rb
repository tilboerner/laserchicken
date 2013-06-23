class Feed < ActiveRecord::Base
	has_many :entries, dependent: :destroy
	has_many :subscriptions, dependent: :destroy

	include FeedsHelper

	after_save :fetch

	def fetch
		update_feed(self)
	end
end
