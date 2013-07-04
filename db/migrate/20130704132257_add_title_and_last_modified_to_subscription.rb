class AddTitleAndLastModifiedToSubscription < ActiveRecord::Migration
  def change
    change_table :subscriptions do |t|
        t.string :title
        t.datetime :last_modified
    end
    Subscription.reset_column_information
    Subscription.all.each do |subs|
      subs.title = subs.feed.title || subs.feed.url || subs.feed.feed_url
      newest = subs.entries.first || Entry.new
      mod = newest.published || subs.feed.last_modified || subs.feed.updated_at
      subs.last_modified = mod
      subs.save!
    end
  end
end
