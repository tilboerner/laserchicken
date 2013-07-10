require 'test_helper'

describe Entry do

  it "cannot be created without given feed" do
    proc { Entry.create!() }.must_raise ActiveRecord::RecordInvalid
  end

  it "can be created with given feed" do
    Entry.create!(feed: feeds(:A)).must_be_instance_of Entry
  end

  it "is unseen for unsubscribed user" do
    Subscription.delete_all
    assert entries(:A1).unseen? users(:some_user)
  end

  it "is unseen for newly subscribed user" do
    Subscription.delete_all
    subscribing_user = users(:some_user)
    Subscription.create(user: subscribing_user, feed: feeds(:A))
    assert entries(:A1).unseen? subscribing_user
  end

  it "is subscribed if user has subscribed to feed" do
    entry = Feed.take.entries.first
    Subscription.create!(user: users(:some_user), feed: Feed.take)
    assert entry.subscribed_by? users(:some_user)
  end

  it "is not subscribed if user has not subscribed to feed" do
    refute entries(:A1).subscribed_by? users(:some_user)
  end

  it "has an empty text if no content or summary exist" do
    entry = Entry.new(feed: Feed.take)
    entry.text.must_be_empty
  end

  it "has an empty snippet if no content or summary exist" do
    entry = Entry.new(feed: Feed.take)
    entry.snippet.must_be_empty
  end

  it "prefers content over summary for its text" do
    entry = Entry.new(feed: Feed.take, content: 'content', summary: 'summary')
    entry.text.must_equal 'content'
  end

  it "prefers summary over content for its snippet" do
    entry = Entry.new(feed: Feed.take, content: 'content', summary: 'summary')
    entry.snippet.must_equal 'summary'
  end

  it "has a mutable and savable user state even without prior interaction" do
    user = User.take
    entry = Entry.take
    state = entry.userstate user

    state.must_be_instance_of UserState, "must have a userstate"
    state.seen = true
    assert state.save, "must be mutable and savable"
  end

end
