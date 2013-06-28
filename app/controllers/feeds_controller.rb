class FeedsController < ApplicationController
	include FeedsHelper

	def index
		@feeds = Feed.all
	end

	def show
		@feed = update_feed(Feed.find(params[:id]))
		@parent = @feed
	end

	def create
		@feed = Feed.create!(params.require(:feed).permit(:feed_url))
		redirect_to feeds_path
	rescue ActiveRecord::RecordInvalid
		flash[:error] = "Not a valid feed: #{params[:feed][:feed_url]}"
		redirect_to :back
	end

	def destroy
		@feed = Feed.find(params[:id])
		@feed.destroy
		redirect_to feeds_path
	end


	def refresh
		render json: params
	end

	def refresh_all
		call_rake :refresh_active_feeds
		flash[:notice] = 'updating all active feeds'
		redirect_to :back
	end

end
