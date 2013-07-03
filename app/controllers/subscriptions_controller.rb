class SubscriptionsController < ApplicationController
	include EntriesHelper

	helpers()

	def index
		@subscriptions = current_user.subscriptions
		if params[:unseen]
			@subscriptions = @subscriptions.changed_for(current_user)
		end
	end

	def show
		@subscription = current_user.subscriptions.find(params[:id])
		@parent = @subscription
		entries_context
	end

	def create
		url = params.require(:subscription).permit(:feed_url)
		feed = Feed.find_or_create_by!(url)
		subscription = Subscription.find_or_create_by(user: current_user, feed: feed)
		flash[:success] = "Subscribed to feed #{feed.title}"
		redirect_to subscription
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
