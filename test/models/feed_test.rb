require 'test_helper'

def valid_feed
  Feed.new(feed_url: 'http://www.feedforall.com/sample-feed.xml')
end

def create_valid_feed
  Feed.create!(feed_url: 'http://www.feedforall.com/sample-feed.xml')
end

describe Feed do

  it 'cannot be created without feed_url' do
    refute Feed.new.save
  end

  it 'cannot be created with an invalid feed_url' do
    refute Feed.new(feed_url: 'invalid url').save
  end

  it 'cannot have a duplicate feed_url' do
    assert Feed.new(feed_url: Feed.take.feed_url).invalid?
  end

  it 'can be created with unique and valid feed_url' do
    assert Feed.create(feed_url: valid_feed.feed_url)
  end

  it 'is inactive without subscriptions' do
    feed = Feed.take
    feed.subscriptions.must_be_empty

    refute feed.active?
  end

  it 'is active when valid and subscribed' do
    feed = create_valid_feed
    Subscription.create!(feed: feed, user: User.take)

    assert feed.active?
  end

  it 'is created without subscriptions' do
    create_valid_feed.subscriptions.must_be_empty
  end

end
