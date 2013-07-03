class FeedsController < ApplicationController
	include FeedsHelper

	before_filter :require_admin_user

	def index
		@feeds = Feed.all
	end

	def show
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
		call_rake :update_feed, feed_id: params[:id].to_i
		flash[:notice] = 'updating feed ' + (@feed.title or @feed.feed_url)
		redirect_to :back
	rescue ActionController::RedirectBackError
		redirect_to feeds_path
	end

	def refresh_all
		call_rake :update_active_feeds
		flash[:notice] = 'updating all active feeds'
		redirect_to :back
	rescue ActionController::RedirectBackError
		redirect_to feeds_path
	end

end
