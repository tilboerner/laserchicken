class EntriesController < ApplicationController

	def index
		@feed = Feed.find(params[:feed_id])
		@entries = @feed.entries
	end

	def show
		@feed = Feed.find(params[:feed_id])
		@entry = @feed.entries.find(params[:id])
	end

end
