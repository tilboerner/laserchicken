class FeedValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if [nil, 0].include? Feedzirra::Feed.fetch_and_parse(value)
      record.errors[attribute] << (options[:message] || "is not a recognized XML feed")
    end
  end
end

class Feed < ActiveRecord::Base
	include FeedsHelper

  validates :feed_url, presence: true, uniqueness: true, feed: true

  has_many :entries, dependent: :destroy
  has_many :subscriptions, inverse_of: :feed, dependent: :destroy

  scope :active, -> { joins(:subscriptions).group('feeds.id').readonly(false) }

  after_create :fetch
  before_save :uniencode_binary_etags

	def fetch
		update_feed(self)
	end

  def active?
    subscriptions.count > 0
  end

private

  def uniencode_binary_etags
    if self.etag && self.etag.encoding == Encoding::ASCII_8BIT
      self.etag.encode!(Encoding::UTF_8)
    end
  end

end
