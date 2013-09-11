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
		if parser.updated? or parser.has_new_entries?
			logger.info "Updating feed #{feedmodel.id} '#{feedmodel.feed_url}'"
			update_feed_from_parser(feedmodel, parser)
			logger.info "done"
		else
			logger.debug "feed unchanged: #{feedmodel.id} '#{feedmodel.feed_url}'"
		end
		feedmodel
	end

private

	FEED_UPDATABLE_ATTRIBUTES = %w(title url last_modified etag)

	def model_to_parser(model)
		# https://gist.github.com/pauldix/132671
		p = Feedzirra::Parser::RSS.new
		relevant_attributes = FEED_UPDATABLE_ATTRIBUTES + ['feed_url']
		relevant_attributes.each do |name|
			p.send "#{name}=", model.send(name)
		end
		if last_entry = model.entries.reorder(:id).last
			latest = Feedzirra::Parser::RSSEntry.new
			latest.url = last_entry.url
			p.entries = [latest]
		end
		p
	end

	def update_feed_from_parser(feedmodel, parser)
		feedmodel.with_lock do
			update_model_attributes(feedmodel, parser) if parser.updated?
			create_entries(feedmodel, parser.new_entries) if parser.has_new_entries?
			feedmodel.subscriptions.each { |s| s.update_dependent_fields }
		end
	end

	def update_model_attributes(model, parser)
		FEED_UPDATABLE_ATTRIBUTES.each do |name|
			original_value = model.send name
			new_value = parser.send name
			unless new_value.nil? || new_value == original_value
				logger.info "#{name}: #{original_value} -> #{new_value}"
				model.update_attribute(name, new_value)		# skip validation (!!!), which would http-get the feed again
			end
		end
	end

	def create_entries(feedmodel, new_entries)
		newcount = new_entries.size
		logger.info "Processing #{newcount} new " + 'entry'.pluralize(newcount)
		ActiveRecord::Base.transaction do
			new_entries.reverse_each do |e|
				e.sanitize!
				feedmodel.entries.create e.instance_values.slice 'title', 'url', 'author', 'summary', 'content', 'published'
			end
		end
	end

end
