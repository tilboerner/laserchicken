class FeedsController < ApplicationController
	include FeedsHelper

	def index
		@feeds = Feed.all
	end

	def show
		@feed = update_feed(Feed.find(params[:id]))
	end

	def create
		@feed = create_feed(params.require(:feed)[:feed_url])
		redirect_to feeds_path
	end


	def destroy
		@feed = Feed.find(params[:id])
		@feed.destroy
		redirect_to feeds_path
	end

end
