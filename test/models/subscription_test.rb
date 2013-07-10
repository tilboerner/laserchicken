require 'test_helper'

def a_fresh_subscription(options = {})
  options = {user: User.take, feed: Feed.take}.merge(options)
  Subscription.create!(options)
end


describe Subscription do

  it 'cannot be created without feed or user' do
    refute Subscription.new(feed: Feed.take).save, "must not be valid without user"
    refute Subscription.new(user: User.take).save, "must not be valid without feed"
  end

  it 'can be created with feed and user' do
    assert Subscription.new(feed: Feed.take, user: User.take).save
  end

  it 'must have (newcount == feed entries) after creation' do
    subs = a_fresh_subscription
    subs.newcount.must_equal subs.feed.entries.count
  end

  it 'must be changed if there are unread entries' do
    subs = a_fresh_subscription

    subs.newcount.must_be '>', 0
    assert subs.changed?
  end

  it 'must be unchanged if no unread entries' do
    subs = a_fresh_subscription
    subs.feed.entries.delete_all

    subs.newcount.must_be '==', 0
    refute subs.changed?
  end

  it 'must be unchanged if only read entries' do
    subs = a_fresh_subscription
    subs.feed.entries.each { |e| e.userstate(subs.user).update(seen: true) }

    subs.newcount.must_be '==', 0
    refute subs.changed?
  end

  it 'must be in changed scope for unsubscribed user' do
    subs = a_fresh_subscription(user: users(:some_user))

    Subscription.changed_for(users(:other_user)).must_include subs
  end

  it 'must be in changed scope when changed' do
    subs = a_fresh_subscription(user: users(:some_user))
    assert subs.changed?

    Subscription.changed_for(users(:some_user)).must_include subs
  end

  it 'must not be in changed scope when unchanged' do
    subs = a_fresh_subscription(user: users(:some_user))
    subs.feed.entries.delete_all
    refute subs.changed?

    Subscription.changed_for(users(:some_user)).must_be_empty
  end

  it 'must not leak change state to other users' do
    subs = a_fresh_subscription(user: users(:some_user))
    other_subs = a_fresh_subscription(user: users(:other_user))
    subs.entries.each { |e| e.userstate(subs.user).update(seen: true) }


    refute subs.changed?
    assert other_subs.changed?
    Subscription.changed_for(users(:some_user)).must_be_empty
    Subscription.changed_for(users(:other_user)).must_include other_subs
  end

  it 'must not be in starred scope when no entries have stars' do
    subs = a_fresh_subscription
    Entry.starred_by(subs.user).must_be_empty

    Subscription.with_stars.must_be_empty
  end

  it 'must be in starred scope when some entries have stars' do
    subs = a_fresh_subscription
    subs.entries.take.userstate(subs.user).update(starred: true)
    subs.entries.starred_by(subs.user).wont_be_empty

    Subscription.with_stars.must_include subs
  end

end
