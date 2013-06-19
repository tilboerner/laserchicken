module FeedsHelper

	def create_feed(url)
		fz = Feedzirra::Feed.fetch_and_parse(url)
		Feed.new fz.instance_values.slice 'title', 'url', 'feed_url', 'etag', 'last_modified'
	end

end
