module FeedsHelper
	require 'nokogiri'
	require 'opml-reader'

	class OpmlFeed
		include Opml::Reader
		attr_accessor :head, :outlines
	end

	def update_feed(feedmodel)
		parser = model_to_parser(feedmodel)
		Feedzirra::Feed.update(parser)
		if parser.updated?
			create_entries(feedmodel, parser.new_entries)
			updatable_attributes = parser.instance_values.slice('title', 'url', 'feed_url', 'etag', 'last_modified')
			updatable_attributes.each do |name, value|
				feedmodel.update_attribute(name, value)		# skip feed validation, as it would try to fetch the feed again
			end
		else
			feedmodel.touch
		end
		feedmodel
	end

private

	def model_to_parser(model)
		# https://gist.github.com/pauldix/132671
		p = Feedzirra::Parser::RSS.new
		p.feed_url = model.feed_url
		p.etag = model.etag
		p.last_modified = model.last_modified
		if model.entries.first
			latest = Feedzirra::Parser::RSSEntry.new
			latest.url = model.entries.first.url
			p.entries = [latest]
		end
		p
	end

	def create_entries(feedmodel, new_entries)
		ActiveRecord::Base.transaction do
			for e in new_entries
				e.sanitize!
				feedmodel.entries.create e.instance_values.slice 'title', 'url', 'author', 'summary', 'content', 'published'
			end
		end
	end

end
