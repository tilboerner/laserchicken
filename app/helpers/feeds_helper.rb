module FeedsHelper

	def create_feed(url)
		feedparser = Feedzirra::Feed.fetch_and_parse(url)
		feed = parser_to_model(feedparser)
		feed.save
		create_entries(feed, feedparser.entries)
		feed
	end


	def update_feed(feedmodel)
		parser = model_to_parser(feedmodel)
		Feedzirra::Feed.update(parser)
		if parser.updated?
			create_entries(feedmodel, parser.new_entries)
			feedmodel.update(parser.instance_values.slice 'title', 'url', 'feed_url', 'etag', 'last_modified')
		end
		feedmodel
	end


private

	def parser_to_model(p)
		Feed.new p.instance_values.slice 'title', 'url', 'feed_url', 'etag', 'last_modified'
	end
	
	def model_to_parser(model)
		# https://gist.github.com/pauldix/132671
		p = Feedzirra::Parser::RSS.new
		p.feed_url = model.feed_url
		p.etag = model.etag
		p.last_modified = model.last_modified
		p
	end

	def create_entries(feedmodel, new_entries)
		for e in new_entries
			feedmodel.entries.create e.instance_values.slice 'title', 'url', 'author', 'summary', 'content', 'published'
		end
	end

end
