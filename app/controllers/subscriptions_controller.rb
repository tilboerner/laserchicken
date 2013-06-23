class SubscriptionsController < ApplicationController

def index
	@subscriptions = Subscription.where(user: current_user)
end

def show
	@subscription = Subscription.where(user: current_user).find(params[:id])
end

def new
end

def create
	url = params.require(:subscription).permit(:feed_url)
	feed = Feed.find_or_create_by(url)
	subscription = Subscription.find_or_create_by(user: current_user, feed: feed)
	redirect_to subscription
end

def destroy
	subscription = Subscription.find(params[:id])
	subscription.destroy
	redirect_to subscriptions_path
end

end
