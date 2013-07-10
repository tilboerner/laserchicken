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

  it "is unseen for new subscriber" do
    Subscription.delete_all
    subscribing_user = users(:some_user)
    Subscription.create(user: subscribing_user, feed: feeds(:A))
    assert entries(:A1).unseen? subscribing_user
  end

  it "is subscribed when feed subscribed" do
    entry = Feed.take.entries.first
    Subscription.create!(user: users(:some_user), feed: Feed.take)
    assert entry.subscribed_by? users(:some_user)
  end

  it "is not subscribed when feed not subscribed" do
    refute entries(:A1).subscribed_by? users(:some_user)
  end

  it "has an empty text if no content or summary" do
    entry = Entry.new(feed: Feed.take)
    entry.text.must_be_empty
  end

  it "has an empty snippet if no content or summary" do
    entry = Entry.new(feed: Feed.take)
    entry.snippet.must_be_empty
  end

  it "prefers content over summary for text" do
    entry = Entry.new(feed: Feed.take, content: 'content', summary: 'summary')
    entry.text.must_equal 'content'
  end

  it "prefers summary over content for snippet" do
    entry = Entry.new(feed: Feed.take, content: 'content', summary: 'summary')
    entry.snippet.must_equal 'summary'
  end

  it "has mutable and savable userstate" do
    user = User.take
    entry = Entry.take
    state = entry.userstate user

    state.must_be_instance_of UserState, "must have a userstate"
    state.seen = true
    assert state.save, "must be mutable and savable"
  end

  it "is in seen scope when seen" do
    entry = Entry.take
    user = User.take

    entry.userstate(user).update(seen: true)

    Entry.seen_by(user).must_include entry
  end

  it "is in unseen scope when unseen" do
    entry = Entry.take
    user = User.take

    entry.userstate(user).update(seen: false)

    Entry.seen_by(user).wont_include entry
  end

  it "must not leak seen state across users" do
    entry = Entry.take

    entry.userstate(users(:some_user)).update(seen: true)

    Entry.seen_by(users(:some_user)).must_include entry, 'seen when seen'
    Entry.seen_by(users(:other_user)).wont_include entry, 'not seen when unseen'
    Entry.unseen_by(users(:some_user)).wont_include entry, 'not unseen when seen'
    Entry.unseen_by(users(:other_user)).must_include entry, 'unseen when unseen'
  end

end
