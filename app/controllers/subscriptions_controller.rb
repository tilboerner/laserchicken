class SubscriptionsController < ApplicationController
	include EntriesHelper

	def index
		@subscriptions = Subscription.where(user: current_user)
		if params[:unseen]
			@subscriptions = @subscriptions.changed_for(current_user)
		end
	end

	def show
		@subscription = Subscription.where(user: current_user).find(params[:id])
		@parent = @subscription
		entries_context
	end

	def new
	end

	def create
		url = params.require(:subscription).permit(:feed_url)
		feed = Feed.find_or_create_by!(url)
		subscription = Subscription.find_or_create_by(user: current_user, feed: feed)
		flash[:success] = "Subscribed to feed #{feed.title}"
		redirect_to subscription
	rescue ActiveRecord::RecordInvalid
		flash[:error] =  "Not a valid feed: #{url[:feed_url]}"
		redirect_to :back
	end

	def destroy
		subscription = Subscription.find(params[:id])
		subscription.destroy
		redirect_to :back
	rescue ActionController::RedirectBackError
		redirect_to subscriptions_path
	end

end
