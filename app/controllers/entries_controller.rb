class EntriesController < ApplicationController

  def index
    establish_context
  end

  def show
    establish_context
  end

  def next
    establish_context
    next_entry = @entries.select('entries.id').where('entries.published < ?', @entry.published).order('published DESC').limit(1).first
    redirect_to next_entry
    unless params[:unseen]
      redirect_to [@parent, next_entry]
    else
      redirect_to polymorphic_path([@parent, next_entry], unseen: true)
    end
  end

  def prev
    establish_context
    next_entry = @entries.select('entries.id').where('entries.published > ?', @entry.published).order('published ASC').limit(1).first
    unless params[:unseen]
      redirect_to [@parent, next_entry]
    else
      redirect_to polymorphic_path([@parent, next_entry], unseen: true)
    end
  end

private

  def establish_context
    if params.include? :id
      @entry = Entry.find(params[:id])
    end
    if params.include? :feed_id
      feed = Feed.find(params[:feed_id])
      @title = feed.title
      @entries = feed.entries
      @parent = feed
    elsif params.include? :subscription_id
      subscription = Subscription.find(params[:subscription_id])
      feed = subscription.feed
      @title = feed.title
      @entries = feed.entries
      @parent = subscription
    else
      @title = 'all'
      @entries = Entry.subscribed_by(current_user)
      @parent = nil
    end
    if params[:unseen]
      @entries = @entries.unseen_by(current_user)
    end
  end

end
