class EntriesController < ApplicationController

	def index
		@feed = Feed.find(params[:feed_id])
		@entries = @feed.entries		
	end

end
