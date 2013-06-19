class FeedsController < ApplicationController
	include FeedsHelper

	def index
		@feeds = Feed.all
	end


	def create
		@feed = create_feed(params.require(:feed)[:feed_url])
		@feed.save
		redirect_to feeds_path
	end


	def destroy
		@feed = Feed.find(params[:id])
		@feed.destroy
		redirect_to feeds_path
	end

end
