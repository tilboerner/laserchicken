class EntriesController < ApplicationController

	def index
    if params.include? :feed_id
      feed = Feed.find(params[:feed_id])
      @title = feed.title
      @entries = feed.entries
    elsif params.include? :subscription_id
      feed = Subscription.find(params[:subscription_id]).feed
      @title = feed.title
      @entries = feed.entries
    else
      @title = 'all'
      @entries = Entry.subscribed_by(current_user)
    end
    if params[:unseen]
      @entries = @entries.unseen_by(current_user)
    end
	end

	def show
		@entry = Entry.find(params[:id])
	end

end
