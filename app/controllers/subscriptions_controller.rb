class SubscriptionsController < ApplicationController
	include EntriesHelper

	helpers()

	def index
		@subscriptions = current_user.subscriptions
		if @filters[:unseen]
			@subscriptions = @subscriptions.changed_for(current_user)
		end
		if @filters[:starred]
			@subscriptions = @subscriptions.with_stars
		end
	end

	def show
		@subscription = current_user.subscriptions.find(params[:id])
		@parent = @subscription
		entries_context
	end

	def create
		url = params.require(:subscription).permit(:feed_url)
		feed = Feed.where(url).first_or_create!
		subscription = Subscription.where(user: current_user, feed: feed).first_or_create
		flash[:info] = "Subscribed to feed #{feed.title}"
		redirect_303 subscription
	rescue ActiveRecord::RecordInvalid
		flash[:error] =  "Not a valid feed: #{url[:feed_url]}"
		redirect_back_or_rescue
	end

	def destroy
		subscription = current_user.subscriptions.find(params[:id])
		subscription.destroy
		redirect_back_or_rescue
	end

end
