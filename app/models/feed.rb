class Feed < ActiveRecord::Base
	include FeedsHelper

  has_many :entries, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  scope :active, -> { joins(:subscriptions).group('feeds.id').readonly(false) }

	after_create :fetch

	def fetch
		update_feed(self)
	end

  def active?
    subscriptions.any?
  end

end
